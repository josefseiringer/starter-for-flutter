# Flutter Tank App with Appwrite

Eine Flutter-basierte Tankstellen-App mit Appwrite Backend-Integration, E-Control API für Kraftstoffpreise und Navigation zu Tankstellen.

Diese Anleitung hilft Ihnen, die Tank App schnell zu konfigurieren und zu verwenden.

---

## 🚀 Erste Schritte

### Projekt klonen

Klonen Sie dieses Repository auf Ihren lokalen Rechner:

```bash
git clone https://github.com/josefseiringer/starter-for-flutter
```

---

## ⚙️ Konfiguration

### 1. **Settings-Datei konfigurieren**  

Die App verwendet jetzt eine `settings.ini` Datei anstelle von `.env`:

1. Navigieren Sie zum `assets/` Ordner
2. Benennen Sie `settings_example.ini` in `settings.ini` um:
   ```bash
   cd assets/
   mv settings_example.ini settings.ini
   ```

3. Öffnen Sie `assets/settings.ini` und ersetzen Sie die Platzhalter mit Ihren echten Werten:

```ini
[appwrite]
public_endpoint = <Ihre Appwrite Endpoint URL>
project_id = <Ihre Appwrite Projekt ID>
project_name = <Ihr Projektname>
database_id = <Ihre Database ID>
users_collection_id = <Ihre Users Collection ID>

[ptv]
api_key = <Ihr PTV API Schlüssel>
proxy_base = http://localhost:8010

[econtrol]
link = https://api.e-control.at/sprit/1.0/search/gas-stations/by-address
```

**Wichtig:** Die `settings.ini` Datei ist erforderlich, damit die App funktioniert!

---

## 🛠️ Entwicklungsanleitung

### 2. **Abhängigkeiten installieren**
```bash
flutter pub get
```

### 3. **App ausführen**
Wählen Sie ein Zielgerät und starten Sie die App:

```bash
# Verfügbare Geräte anzeigen
flutter devices

# App auf einem bestimmten Gerät ausführen
flutter run -d device-id

# Beispiele:
flutter run -d chrome                           # Web
flutter run -d "iPhone von Josef"               # iOS Gerät
flutter run -d 00008140-000604E00261801C        # iPhone (Device ID)
flutter run -d emulator-5554                    # Android Emulator
flutter run -d macos                            # macOS Desktop

# Profile-Modus für Performance-Analyse
flutter run --profile -d 00008140-000604E00261801C # <-- mit UID des Iphones
flutter run --profile # <-- ohne UID
```

---

## 📱 App-Features

### ⛽ **Tank-Funktionalität:**
- **Tankstellen-Finder**: Top 5 Tankstellen in der Nähe
- **Kraftstoffpreise**: Aktuelle Diesel/Super Preise via E-Control API
- **Navigation**: Direkte Weiterleitung zu Apple Maps/Google Maps
- **Tankstopps verwalten**: Eigene Tankstopps speichern und verwalten

### 🗺️ **Navigation:**
- iOS: Apple Maps Integration
- Android: Google Maps Integration
- Web/Desktop: Google Maps im Browser

### 📊 **Daten-Management:**
- Appwrite Backend-Integration
- Lokale und Cloud-Datenspeicherung
- Benutzerauthentifizierung

---

## 🏗️ Produktions-Build

### iOS Build:
```bash
# Profile-Build für Debugging
flutter build ios --profile

# Release-Build für App Store
flutter build ios --release
```

### Android Build:
```bash
flutter build apk --release
```

### Web Build:
```bash
flutter build web
```

---

## 🔧 Technische Details

### **Architektur:**
- **State Management**: GetX
- **Backend**: Appwrite
- **API Integration**: E-Control (Kraftstoffpreise)
- **Maps**: url_launcher für plattformspezifische Navigation
- **Konfiguration**: INI-basierte Settings

### **Ordnerstruktur:**
```
lib/
├── config/
│   ├── settings_service.dart    # INI-Konfiguration
│   └── environment.dart         # Environment-Wrapper
├── data/
│   ├── controller/              # GetX Controller
│   ├── models/                  # Datenmodelle
│   └── repository/              # API-Repositories
└── ui/
    ├── components/              # UI-Komponenten
    └── pages/                   # App-Seiten

assets/
├── settings.ini                 # Haupt-Konfiguration
└── settings_example.ini         # Beispiel-Konfiguration
```

---

## 🍎 iOS Deployment

### **Provisioning Profile:**
- **Kostenloser Account**: 7 Tage Gültigkeit
- **Paid Developer Account**: 1 Jahr Gültigkeit

### **Installation auf iPhone:**
1. iPhone per USB verbinden
2. `flutter run --profile -d [device-id]` ausführen
3. App ist als native iOS-App installiert

---

## 💡 Zusätzliche Hinweise

- **Erstmalige Einrichtung**: `settings.ini` muss korrekt konfiguriert sein
- **API-Schlüssel**: E-Control API erfordert keine Authentifizierung
- **PTV API**: Optional für erweiterte Standortdienste
- **Appwrite**: Für Benutzerauthentifizierung und Datenspeicherung

Weitere Details zur Appwrite-Integration finden Sie in der [Appwrite Dokumentation](https://appwrite.io/docs).

---

## 🆘 Fehlerbehebung

### Häufige Probleme:

1. **"settings.ini not found"**: 
   - Stellen Sie sicher, dass `settings_example.ini` zu `settings.ini` umbenannt wurde

2. **"Network connection error"**: 
   - Überprüfen Sie die Appwrite Endpoint-URL in der `settings.ini`

3. **"Module device_info_plus not found"**: 
   - Führen Sie `flutter clean && flutter pub get` aus

4. **iOS Provisioning abgelaufen**: 
   - Führen Sie `flutter run` erneut aus (kostenloser Account)

---

**🚗 Viel Spaß mit Ihrer Tank App! ⛽**