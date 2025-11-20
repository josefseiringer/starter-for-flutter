import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/environment.dart';
import '../../../config/settings_service.dart';
import '../../ui/pages/login_view.dart';

class SettingsController extends GetxController {
  final apiEndpointController = TextEditingController();
  final projectNameController = TextEditingController();
  final projectIdController = TextEditingController();
  final databaseIdController = TextEditingController();
  final usersCollectionIdController = TextEditingController();
  final ptvApiKeyController = TextEditingController();
  final ptvProxyBaseController = TextEditingController();
  final eControlLinkController = TextEditingController();

  // ...existing code...

  @override
  void onInit() {
    apiEndpointController.text = Environment.appwritePublicEndpoint;
    projectNameController.text = Environment.appwriteProjectName;
    projectIdController.text = Environment.appwriteProjectId;
    databaseIdController.text = Environment.appwriteDatabaseId;
    usersCollectionIdController.text = Environment.appwriteUsersCollectionId;
    ptvApiKeyController.text = Environment.ptvApiKey;
    ptvProxyBaseController.text = Environment.ptvProxyBase;
    eControlLinkController.text = Environment.eControlLink;
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    apiEndpointController.dispose();
    projectNameController.dispose();
    projectIdController.dispose();
    databaseIdController.dispose();
    usersCollectionIdController.dispose();
    ptvApiKeyController.dispose();
    ptvProxyBaseController.dispose();
    eControlLinkController.dispose();
    super.onClose();
  }

  void goToLogin() {
    Get.offAndToNamed(LoginPage.namedRoute);
  }

  void onError(error) {
    Get.snackbar('Fehler', 'Fehler beim Speichern der Einstellungen: $error',
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  void onSuccsess() {
    Get.snackbar('Erfolg', 'Einstellungen erfolgreich gespeichert',
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void saveSettings(String switchValue) async {
    // settings.ini wird upgetatet
    switch (switchValue) {
      case 'apiEndpoint':
        await SettingsService.set(
                'appwrite', 'public_endpoint', apiEndpointController.text)
            .then((_) {
          onSuccsess();
        }).catchError((error) {
          onError(error);
        });
        break;
      case 'projectName':
        await SettingsService.set(
            'appwrite', 'project_name', projectNameController.text).then((_){
          onSuccsess();
        }).catchError((error){
          onError(error);
            });
        break;
      case 'projectId':
        await SettingsService.set('appwrite', 'project_id', projectIdController.text).then((_){
          onSuccsess();
        }).catchError((error){
          onError(error);
            });
        break;
      case 'databaseId':
        await SettingsService.set(
            'appwrite', 'database_id', databaseIdController.text).then((_){
          onSuccsess();
        }).catchError((error){
          onError(error);
            });
        break;
      case 'usersCollectionId':
        await SettingsService.set('appwrite', 'users_collection_id',
            usersCollectionIdController.text).then((_){
          onSuccsess();
        }).catchError((error){
          onError(error);
            });
        break;
      case 'ptvApiKey':
        await SettingsService.set('ptv', 'api_key', ptvApiKeyController.text).then((_){
          onSuccsess();
        }).catchError((error){
          onError(error);
            });
        break;
      case 'ptvProxyBase':
        await SettingsService.set('ptv', 'proxy_base', ptvProxyBaseController.text).then((_){
          onSuccsess();
        }).catchError((error){
          onError(error);
            });
        break;
      case 'eControlLink':
        await SettingsService.set('econtrol', 'link', eControlLinkController.text).then((_){
          onSuccsess();
        }).catchError((error){
          onError(error);
            });
        break;
      default:
        break;
    }
  }
}
