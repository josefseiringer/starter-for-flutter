import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/controller/settings_controller.dart';
import '../components/my_card_text_form_with_button.dart';

class SettingsPage extends GetView<SettingsController> {
  static const String namedRoute = '/settings-page';
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsCtrl = controller;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => settingsCtrl.goToLogin(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('Einstellungen'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => settingsCtrl.saveSettings(),
                icon: const Icon(Icons.save),
              )
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
            ),
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                MyCardTextFormWithButton(
                  controller: settingsCtrl.apiEndpointController,
                  labelTextFormField: 'API Endpoint',
                  onPressedButton: () => settingsCtrl.saveSettings(),
                  buttonText: 'Update',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

