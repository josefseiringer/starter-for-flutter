import 'dart:io';
import 'package:flutter/services.dart';
import 'package:ini/ini.dart';
import 'package:path_provider/path_provider.dart';

class SettingsService {
  static Config? _config;
  static const String _settingsFile = 'settings.ini';
  static String? _settingsFilePath;

  // Hole den Pfad zur beschreibbaren settings.ini Datei
  static Future<String> _getSettingsFilePath() async {
    if (_settingsFilePath != null) {
      return _settingsFilePath!;
    }
    
    try {
      final directory = await getApplicationDocumentsDirectory();
      _settingsFilePath = '${directory.path}/$_settingsFile';
    } catch (e) {
      // Fallback für Plattformen ohne path_provider Support
      // Verwende lokales Verzeichnis
      _settingsFilePath = _settingsFile;
      print('path_provider nicht verfügbar, verwende lokales Verzeichnis: $_settingsFilePath');
    }
    
    return _settingsFilePath!;
  }

  // INI-Datei laden
  static Future<void> loadSettings() async {
    try {
      // Lade immer aus Assets beim Start
      print('Lade Settings aus Assets...');
      String content = await rootBundle.loadString('assets/$_settingsFile');
      _config = Config.fromString(content);
      print('Settings aus Assets geladen');
      
      // Versuche auch aus beschreibbarem Verzeichnis zu laden (überschreibt Assets-Werte)
      try {
        String filePath = await _getSettingsFilePath();
        File file = File(filePath);
        
        print('Settings-Pfad: $filePath');
        
        if (await file.exists()) {
          print('Lade zusätzliche Settings aus beschreibbarem Verzeichnis...');
          String fileContent = await file.readAsString();
          Config fileConfig = Config.fromString(fileContent);
          
          // Merge: Überschreibe Asset-Werte mit Dateisystem-Werten
          for (String section in fileConfig.sections()) {
            Iterable<String>? keys = fileConfig.options(section);
            if (keys != null) {
              for (String key in keys) {
                String? value = fileConfig.get(section, key);
                if (value != null) {
                  _config!.set(section, key, value);
                }
              }
            }
          }
          print('Settings aus Dateisystem gemerged');
        } else {
          print('Keine Settings-Datei im Dateisystem gefunden, verwende nur Assets');
        }
      } catch (fileError) {
        print('Konnte nicht aus Dateisystem laden (nicht kritisch): $fileError');
        // Nicht kritisch - wir haben bereits die Assets geladen
      }
      
      // Prüfe ob Config geladen wurde
      if (_config != null) {
        print('Config geladen mit ${_config!.sections().length} Sektionen');
      } else {
        print('WARNUNG: Config ist null!');
      }
    } catch (e, stackTrace) {
      print('FEHLER beim Laden der settings.ini: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Fehler beim Laden der settings.ini: $e');
    }
  }

  // Wert auslesen
  static String? get(String section, String key) {
    if (_config == null) {
      // Gebe null zurück statt Exception zu werfen
      // Das ermöglicht, dass Environment-Getter funktionieren, auch wenn Settings noch nicht geladen sind
      return null;
    }
    return _config!.get(section, key);
  }

  // Wert setzen und speichern
  static Future<void> set(String section, String key, String value) async {
    _config ??= Config();
    
    _config!.set(section, key, value);
    await _saveSettings();
  }

  // INI-Datei speichern
  static Future<void> _saveSettings() async {
    if (_config == null) {
      throw Exception('Config ist null. Kann nicht gespeichert werden.');
    }
    
    try {
      // Konvertiere Config zu INI-String Format
      StringBuffer buffer = StringBuffer();
      
      for (String section in _config!.sections()) {
        buffer.writeln('[$section]');
        
        // Hole alle Keys für diese Section
        Iterable<String>? keys = _config!.options(section);
        if (keys != null) {
          for (String key in keys) {
            String? value = _config!.get(section, key);
            if (value != null) {
              buffer.writeln('$key=$value');
            }
          }
        }
        buffer.writeln(); // Leerzeile zwischen Sektionen
      }
      
      // Schreibe in beschreibbares Verzeichnis
      String filePath = await _getSettingsFilePath();
      
      // Erstelle Verzeichnis falls nicht vorhanden (nur wenn path_provider funktioniert)
      try {
        if (filePath.contains(Platform.pathSeparator)) {
          final dir = Directory(filePath.substring(0, filePath.lastIndexOf(Platform.pathSeparator)));
          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }
        }
      } catch (dirError) {
        print('Konnte Verzeichnis nicht erstellen: $dirError');
      }
      
      File file = File(filePath);
      await file.writeAsString(buffer.toString());
      print('Settings erfolgreich gespeichert in: $filePath');
    } catch (e) {
      print('Fehler beim Speichern der settings.ini: $e');
      // Werfe nur eine Warnung, App soll weiterlaufen
      print('WARNUNG: Settings konnten nicht gespeichert werden. Änderungen gehen beim Neustart verloren.');
    }
  }

  // Convenience-Getter für häufig verwendete Werte
  static String? get appwriteEndpoint => get('appwrite', 'public_endpoint');
  static String? get appwriteProjectId => get('appwrite', 'project_id');
  static String? get appwriteProjectName => get('appwrite', 'project_name');
  static String? get appwriteDatabaseId => get('appwrite', 'database_id');
  static String? get appwriteUsersCollectionId => get('appwrite', 'users_collection_id');
  
  static String? get ptvApiKey => get('ptv', 'api_key');
  static String? get ptvProxyBase => get('ptv', 'proxy_base');
  
  static String? get eControlLink => get('econtrol', 'link');

}