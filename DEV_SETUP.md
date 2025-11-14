# Flutter Tank App - Entwicklungsumgebung

## Web Development Setup

### Problem: Location API funktioniert nicht im Web

**Ursache**: Browser-CORS-Policy blockiert Anfragen an `api.myptv.com`

**Lösung**: Lokaler CORS-Proxy für Entwicklung

### Setup in 3 Schritten

#### 1. `.env` Datei konfigurieren

Erstelle/bearbeite `.env` im Projekt-Root:

```env
PTV_API_KEY=dein_ptv_api_schluessel
PTV_PROXY_BASE=http://localhost:8088
```

#### 2. CORS Proxy starten

**Option A: Dart Proxy (empfohlen)**

```bash
dart run cors_proxy.dart
```

Oder doppelklick auf `start-proxy.bat`

**Option B: Node Proxy**

```bash
npx local-cors-proxy --proxyUrl https://api.myptv.com/geocoding/v1 --port 8010 --proxyPartial ""
```

#### 3. Flutter Web starten

```bash
flutter run -d chrome
```

### Wichtig

- Der Proxy **muss laufen** bevor die App startet
- Die App **muss auf localhost** laufen (nicht 192.168.x.x)
- Für Production: Backend-Proxy oder PTV CORS-Freigabe einrichten

### Debugging

Console-Logs zeigen:

```
Building proxy URL: http://localhost:8010/locations/by-position/48.xxx/13.xxx?...
Response status: 200
Response Content-Type: application/json
```

Bei Problemen:

- Prüfe ob Proxy läuft (Terminal-Ausgabe)
- Prüfe `.env` Datei
- Prüfe Browser DevTools Network Tab
- Prüfe PTV_API_KEY Gültigkeit

### Production

Für Production-Deployment:

1. **Backend-Proxy**: Implementiere Server-seitigen Proxy für PTV API
2. **PTV CORS**: Kontaktiere PTV für CORS-Freigabe deiner Domain
3. **Env-Variable**: Setze `PTV_PROXY_BASE` auf Production-Proxy-URL oder leer für Android/iOS

Im Web ohne Proxy wird die App automatisch die Original-PTV-URL nutzen (funktioniert nur mit CORS-Freigabe).
