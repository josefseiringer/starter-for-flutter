import '../config/settings_service.dart';

class Environment {
  static String get appwritePublicEndpoint => SettingsService.appwriteEndpoint ?? '';
  static String get appwriteProjectId => SettingsService.appwriteProjectId ?? '';
  static String get appwriteProjectName => SettingsService.appwriteProjectName ?? '';
  static String get appwriteDatabaseId => SettingsService.appwriteDatabaseId ?? '';
  static String get appwriteUsersCollectionId => SettingsService.appwriteUsersCollectionId ?? '';
  static String get ptvApiKey => SettingsService.ptvApiKey ?? '';
  static String get ptvProxyBase => SettingsService.ptvProxyBase ?? '';
  static String get eControlLink => SettingsService.eControlLink ?? '';
}



