# PTV Geocoding Proxy Server

Production-ready Backend-Proxy für die PTV Geocoding API mit CORS-Support.

## Features

- ✅ CORS-Headers für alle Requests
- ✅ API-Key bleibt serverseitig geheim
- ✅ Health-Check Endpoint
- ✅ Request-Logging
- ✅ Timeout-Handling
- ✅ Error-Handling
- ✅ Environment-basierte Konfiguration

## Setup

### 1. Dependencies installieren

```bash
cd backend_proxy
dart pub get
```

### 2. Environment konfigurieren

Kopiere `.env.example` zu `.env`:

```bash
copy .env.example .env
```

Bearbeite `.env`:

```env
PTV_API_KEY=dein_ptv_api_key
PORT=8088
HOST=0.0.0.0
```

### 3. Server starten

**Development:**

```bash
dart run bin/server.dart
```

**Production (mit Dart AOT kompiliert):**

```bash
dart compile exe bin/server.dart -o ptv_proxy
./ptv_proxy
```

## API Endpoints

### Health Check

```
GET /health
```

Response:

```json
{ "status": "healthy", "service": "PTV Geocoding Proxy" }
```

### Geocoding

```
GET /api/geocode?lat=48.2213888&lng=13.9198464&language=de
```

Parameters:

- `lat` (required): Latitude
- `lng` (required): Longitude
- `language` (optional): Language code (default: 'de')

Response: Direkte PTV API Response (JSON)

## Flutter App Konfiguration

In deiner Flutter App `.env`:

**Development (lokaler Proxy):**

```env
PTV_PROXY_BASE=http://localhost:8010
```

**Production (dieser Server):**

```env
PTV_PROXY_BASE=https://your-domain.com
```

Dann in `location_repository.dart` den Pfad anpassen:

```dart
// Statt: '$cleanBase/locations/by-position/$lat/$lng?...'
// Nutze: '$cleanBase/api/geocode?lat=$lat&lng=$lng&language=de'
```

## Deployment Optionen

### Option 1: Docker

```dockerfile
FROM dart:stable AS build
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN dart compile exe bin/server.dart -o server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/server /app/
COPY --from=build /app/.env /app/
EXPOSE 8088
CMD ["/app/server"]
```

### Option 2: VPS/Cloud Server

```bash
# Kompiliere zu native executable
dart compile exe bin/server.dart -o ptv_proxy

# Als systemd service einrichten
sudo nano /etc/systemd/system/ptv-proxy.service
```

### Option 3: Cloud Functions

- Google Cloud Run
- AWS Lambda (mit Custom Runtime)
- Azure Functions
- DigitalOcean App Platform

### Option 4: Heroku/Railway/Fly.io

Erstelle `Procfile`:

```
web: dart run bin/server.dart
```

## Sicherheit für Production

1. **Rate Limiting**: Füge Rate-Limiting hinzu (z.B. `shelf_limiter`)
2. **API Key Rotation**: Regelmäßig PTV API Key erneuern
3. **HTTPS**: Nutze SSL/TLS (Let's Encrypt, Cloudflare)
4. **Domain Whitelist**: CORS nur für deine Domain erlauben:
   ```dart
   'Access-Control-Allow-Origin': 'https://your-app-domain.com'
   ```
5. **Request Validation**: Validiere lat/lng Ranges
6. **Logging**: Implementiere strukturiertes Logging
7. **Monitoring**: Health-Check für Uptime-Monitoring

## Monitoring

Der `/health` Endpoint kann von Monitoring-Tools genutzt werden:

- UptimeRobot
- Pingdom
- StatusCake
- Cloud Provider Health Checks

## Performance

**Caching** (optional):

```dart
// In-Memory Cache für häufige Anfragen
final cache = <String, CachedResponse>{};
```

**Load Balancing**:
Nutze mehrere Instanzen hinter einem Load Balancer (nginx, Cloud LB).

## Troubleshooting

**Port bereits belegt:**

```bash
# Ändere PORT in .env
PORT=8081
```

**PTV API Key ungültig:**

```
❌ ERROR: PTV_API_KEY not found in .env file
```

→ Prüfe `.env` Datei

**CORS Fehler:**
→ Prüfe ob Server läuft und erreichbar ist
→ Prüfe Browser DevTools Network Tab

## Kosten & Limits

- Server: ~5-10€/Monat (einfacher VPS)
- PTV API: Nach deinem PTV Plan
- Traffic: Minimal (nur JSON-Responses)

## Support

Bei Fragen zum Deployment oder Problemen erstelle ein Issue im Repo.
