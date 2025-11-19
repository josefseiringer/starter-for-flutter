import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/environment.dart';
import '../../ui/pages/login_view.dart';

class SettingsController extends GetxController {
  final apiEndpointController = TextEditingController();

  // ...existing code...

  @override
  void onInit() {
    apiEndpointController.text = Environment.appwritePublicEndpoint;
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    apiEndpointController.dispose();
    super.onClose();
  }

  void goToLogin() {
    Get.offAndToNamed(LoginPage.namedRoute);
  }

  void saveSettings() {}

  void saveUpdate() {}
}
