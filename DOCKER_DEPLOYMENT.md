# Docker Deployment Guide

Production-Deployment mit Docker & Docker Compose für Flutter Tank App + PTV Proxy Backend.

## 🏗️ Architektur

```
┌─────────────────────────────────────────┐
│         Reverse Proxy (optional)        │
│         nginx/traefik/caddy             │
└───────────┬─────────────────┬───────────┘
            │                 │
    Port 8089             Port 8088
            │                 │
┌───────────▼──────────┐  ┌──▼────────────────┐
│   Flutter Web App    │  │   PTV Proxy       │
│   (nginx:alpine)     │  │   (Dart Server)   │
│   Port 80 internal   │  │   Port 8088       │
└──────────────────────┘  └───────────────────┘
            │                       │
            └───────────┬───────────┘
                        │
                 Docker Network
```

## 📋 Voraussetzungen

- Docker Engine 20.10+
- Docker Compose 2.0+
- PTV API Key

## 🚀 Deployment in 4 Schritten

### 1. Environment konfigurieren

```bash
# Backend Proxy .env erstellen
cd backend_proxy
cp .env.production .env
nano .env
```

Füge deinen echten PTV API Key ein:

```env
PTV_API_KEY=dein_echter_ptv_key
PORT=8088
HOST=0.0.0.0
```

### 2. Flutter App .env erstellen

```bash
cd ..
cp .env_example .env
nano .env
```

Wichtig: Für Production im Container nutzt die App den Backend-Proxy:

```env
# Production: Über Docker-Netzwerk oder externe URL
PTV_PROXY_BASE=http://ptv-proxy:8088

# Oder wenn extern erreichbar:
# PTV_PROXY_BASE=https://deine-domain.com/api
```

### 3. Build & Start

```bash
# Alle Services bauen und starten
docker-compose up -d --build

# Logs verfolgen
docker-compose logs -f

# Status prüfen
docker-compose ps
```

### 4. Verifizieren

**Backend Proxy Health:**

```bash
curl http://localhost:8088/health
# Erwartung: {"status": "healthy", "service": "PTV Geocoding Proxy"}
```

**Flutter App:**

```bash
curl http://localhost:8089/health
# Erwartung: healthy
```

**Geocoding testen:**

```bash
curl "http://localhost:8088/api/geocode?lat=48.2213888&lng=13.9198464"
# Erwartung: JSON mit Adressdaten
```

## 🔧 Konfiguration

### Ports anpassen

In `docker-compose.yml`:

```yaml
services:
  ptv-proxy:
    ports:
      - "DEIN_PORT:8088"

  flutter-web:
    ports:
      - "DEIN_PORT:80"
```

### Umgebungsvariablen

**Backend Proxy (`backend_proxy/.env`):**

- `PTV_API_KEY` - PTV API Schlüssel (required)
- `PORT` - Interner Port (default: 8088)
- `HOST` - Bind-Address (default: 0.0.0.0)

**Flutter App (`.env`):**

- `PTV_PROXY_BASE` - URL zum Backend Proxy
- `APPWRITE_*` - Appwrite Konfiguration

## 🌐 Reverse Proxy Setup

### nginx

```nginx
# Backend Proxy
location /api/ {
    proxy_pass http://localhost:8088/api/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}

# Flutter Web App
location / {
    proxy_pass http://localhost:8089/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

### Traefik (docker-compose.yml)

```yaml
services:
  ptv-proxy:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.ptv-proxy.rule=Host(`deine-domain.com`) && PathPrefix(`/api`)"
      - "traefik.http.services.ptv-proxy.loadbalancer.server.port=8088"

  flutter-web:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.flutter-web.rule=Host(`deine-domain.com`)"
      - "traefik.http.services.flutter-web.loadbalancer.server.port=80"
```

### Caddy

```
deine-domain.com {
    handle /api/* {
        reverse_proxy localhost:8088
    }
    handle {
        reverse_proxy localhost:8089
    }
}
```

## 📊 Monitoring & Logs

### Logs ansehen

```bash
# Alle Services
docker-compose logs -f

# Nur Backend Proxy
docker-compose logs -f ptv-proxy

# Nur Flutter App
docker-compose logs -f flutter-web

# Letzte 100 Zeilen
docker-compose logs --tail=100
```

### Container Status

```bash
# Übersicht
docker-compose ps

# Resourcen
docker stats flutter-tanken-app ptv-proxy

# Health Status
docker inspect --format='{{.State.Health.Status}}' ptv-proxy
```

## 🔄 Updates & Wartung

### App aktualisieren

```bash
# Code pullen
git pull

# Neu bauen und deployen
docker-compose up -d --build

# Alte Images aufräumen
docker image prune -f
```

### Backup

```bash
# .env Dateien sichern
tar -czf backup-env-$(date +%Y%m%d).tar.gz .env backend_proxy/.env

# Komplettes Backup
tar -czf backup-full-$(date +%Y%m%d).tar.gz --exclude=node_modules --exclude=build .
```

### Logs rotieren

Füge in `docker-compose.yml` hinzu:

```yaml
services:
  ptv-proxy:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## 🐛 Troubleshooting

### Backend Proxy startet nicht

```bash
# Logs checken
docker-compose logs ptv-proxy

# Häufige Fehler:
# - "PTV_API_KEY not found" → .env Datei fehlt oder falsch
# - "Port already in use" → Port 8088 belegt
```

### Flutter App zeigt CORS-Fehler

```bash
# Prüfe ob Backend Proxy erreichbar ist
docker-compose exec flutter-web wget -qO- http://ptv-proxy:8088/health

# Prüfe .env PTV_PROXY_BASE
docker-compose exec flutter-web cat /usr/share/nginx/html/assets/.env
```

### Services neu starten

```bash
# Einzelner Service
docker-compose restart ptv-proxy

# Alle Services
docker-compose restart

# Komplett neu (löscht Container)
docker-compose down
docker-compose up -d
```

## 🔒 Sicherheit

### Production Checklist

- [ ] `.env` Dateien nicht ins Git committen
- [ ] PTV API Key sicher aufbewahren
- [ ] HTTPS über Reverse Proxy aktivieren
- [ ] Firewall: Nur 80/443 öffnen, nicht 8088/8089
- [ ] Health-Checks aktiviert
- [ ] Log-Rotation konfiguriert
- [ ] Backup-Strategie definiert
- [ ] Updates regelmäßig einspielen

### Environment Secrets

Für sensitive Daten Docker Secrets nutzen:

```yaml
secrets:
  ptv_api_key:
    file: ./secrets/ptv_api_key.txt

services:
  ptv-proxy:
    secrets:
      - ptv_api_key
```

## 📈 Performance

### Ressourcen limitieren

```yaml
services:
  ptv-proxy:
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: 512M
        reservations:
          memory: 256M
```

### Caching optimieren

nginx.conf bereits optimiert mit:

- Gzip Compression
- Static Asset Caching (1 Jahr)
- Security Headers

## 📞 Support

Bei Problemen:

1. Logs prüfen: `docker-compose logs -f`
2. Health-Status: `curl localhost:8088/health`
3. Network: `docker network inspect starter-for-flutter_app-network`
4. Issues im Repo erstellen

## 🎯 Production Deployment Beispiele

### DigitalOcean Droplet

```bash
# Docker installieren
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Repository klonen
git clone https://github.com/josefseiringer/starter-for-flutter.git
cd starter-for-flutter

# .env konfigurieren (siehe oben)

# Deployen
docker-compose up -d --build
```

### AWS EC2

Siehe DigitalOcean, zusätzlich:

```bash
# Security Group: Ports 80, 443 öffnen
# Elastic IP zuweisen
# Route53 für Domain konfigurieren
```

### Google Cloud Run

Separates Deployment pro Service (siehe backend_proxy/README.md).

---

**Viel Erfolg beim Deployment! 🚀**
