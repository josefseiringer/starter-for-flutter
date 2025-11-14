# Flutter Web Docker Deployment

## 📋 Voraussetzungen

- Docker installiert
- Docker Compose installiert (optional)

## 🚀 Deployment Optionen

### Option 1: Mit Deploy-Script (Empfohlen)

**Windows (PowerShell):**
```powershell
.\deploy.ps1
```

**Linux/Mac:**
```bash
sed -i 's/\r$//' deploy.sh && chmod +x deploy.sh && ./deploy.sh
```

### Option 2: Mit Docker Compose

```bash
docker-compose up -d --build
```

### Option 3: Manuell mit Docker

```bash
# Build
docker build -t flutter-tanken-app:latest .

# Run
docker run -d --name flutter-tanken-app -p 8080:8088 flutter-tanken-app:latest
```

## 🌐 Zugriff

Nach dem Deployment ist die App erreichbar unter:
- **Lokal**: http://localhost:8088
- **Server**: http://YOUR_SERVER_IP:8088

## 🔧 Konfiguration

### Port ändern

**docker-compose.yml:**
```yaml
ports:
  - "3000:3000"  # Ändere 3000 zum gewünschten Port
```

**Oder beim manuellen Run:**
```bash
docker run -d -p 3000:3000 flutter-tanken-app:latest
```

### Umgebungsvariablen

Erstelle eine `.env.production` Datei:
```env
APPWRITE_PUBLIC_ENDPOINT=https://your-appwrite-server.com/v1
APPWRITE_PROJECT_ID=your-project-id
# ... weitere Variablen
```

## 📊 Container-Verwaltung

```bash
# Status prüfen
docker ps

# Logs anzeigen
docker logs flutter-tanken-app

# Container stoppen
docker stop flutter-tanken-app

# Container starten
docker start flutter-tanken-app

# Container entfernen
docker rm flutter-tanken-app
```

## 🔄 Updates deployen

```bash
# Mit Script
.\deploy.ps1

# Oder mit Docker Compose
docker-compose down
docker-compose up -d --build
```

## 🌍 Production Server Deployment

### 1. Image auf Docker Hub pushen

```bash
docker tag flutter-tanken-app:latest YOUR_DOCKERHUB_USER/flutter-tanken-app:latest
docker push YOUR_DOCKERHUB_USER/flutter-tanken-app:latest
```

### 2. Auf Server pullen und starten

```bash
docker pull YOUR_DOCKERHUB_USER/flutter-tanken-app:latest
docker run -d -p 8088:8088 --restart always YOUR_DOCKERHUB_USER/flutter-tanken-app:latest
```

### 3. Mit Domain und HTTPS (nginx-proxy + Let's Encrypt)

```bash
docker run -d \
  --name flutter-tanken-app \
  -e VIRTUAL_HOST=your-domain.com \
  -e LETSENCRYPT_HOST=your-domain.com \
  -e LETSENCRYPT_EMAIL=your-email@example.com \
  flutter-tanken-app:latest
```

## 🛡️ Security Best Practices

1. **HTTPS verwenden** (Let's Encrypt)
2. **Secrets nicht im Image** - Umgebungsvariablen nutzen
3. **Container als non-root User** laufen lassen
4. **Image regelmäßig updaten**
5. **Security Headers** sind bereits in nginx.conf konfiguriert

## 🐛 Troubleshooting

### Container startet nicht
```bash
docker logs flutter-tanken-app
```

### Port bereits belegt
```bash
# Anderen Port verwenden
docker run -d -p 8089:8088 flutter-tanken-app:latest
```

### Build-Fehler
```bash
# Cache löschen und neu bauen
docker build --no-cache -t flutter-tanken-app:latest .
```
