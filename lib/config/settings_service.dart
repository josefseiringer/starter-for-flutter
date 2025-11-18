import 'dart:io';
import 'package:flutter/services.dart';
import 'package:ini/ini.dart';

class SettingsService {
  static Config? _config;
  static const String _settingsFile = 'settings.ini';

  // INI-Datei laden
  static Future<void> loadSettings() async {
    try {
      // Versuche zuerst aus Assets zu laden
      String content = await rootBundle.loadString('assets/$_settingsFile');
      _config = Config.fromString(content);
    } catch (e) {
      // Fallback: Aus Dateisystem laden
      try {
        File file = File(_settingsFile);
        if (await file.exists()) {
          String content = await file.readAsString();
          _config = Config.fromString(content);
        } else {
          throw Exception('settings.ini nicht gefunden');
        }
      } catch (fileError) {
        throw Exception('Fehler beim Laden der settings.ini: $fileError');
      }
    }
  }

  // Wert auslesen
  static String? get(String section, String key) {
    if (_config == null) {
      throw Exception('Settings nicht geladen. Rufen Sie loadSettings() auf.');
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
    try {
      File file = File(_settingsFile);
      await file.writeAsString(_config.toString());
    } catch (e) {
      throw Exception('Fehler beim Speichern der settings.ini: $e');
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

  // Convenience-Setter
  static Future<void> setAppwriteEndpoint(String value) async {
    await set('appwrite', 'public_endpoint', value);
  }

  static Future<void> setPtvApiKey(String value) async {
    await set('ptv', 'api_key', value);
  }
}