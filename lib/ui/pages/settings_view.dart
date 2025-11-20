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
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
            ),
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                MyCardTextFormWithButton(
                  controller: settingsCtrl.projectNameController,
                  labelTextFormField: 'Project Name',
                  onPressedButton: () => settingsCtrl.saveSettings('projectName'),
                  buttonText: 'Update',
                ),
                SizedBox(height: 5),
                MyCardTextFormWithButton(
                  controller: settingsCtrl.apiEndpointController,
                  labelTextFormField: 'API Endpoint',
                  onPressedButton: () => settingsCtrl.saveSettings('apiEndpoint'),
                  buttonText: 'Update',
                ),
                SizedBox(height: 5),
                MyCardTextFormWithButton(
                  controller: settingsCtrl.projectIdController,
                  labelTextFormField: 'Project ID',
                  onPressedButton: () => settingsCtrl.saveSettings('projectId'),
                  buttonText: 'Update',
                ),
                SizedBox(height: 5),
                MyCardTextFormWithButton(
                  controller: settingsCtrl.databaseIdController,
                  labelTextFormField: 'Database ID',
                  onPressedButton: () => settingsCtrl.saveSettings('databaseId'),
                  buttonText: 'Update',
                ),
                SizedBox(height: 5),
                MyCardTextFormWithButton(
                  controller: settingsCtrl.usersCollectionIdController,
                  labelTextFormField: 'Users Collection ID',
                  onPressedButton: () => settingsCtrl.saveSettings('usersCollectionId'),
                  buttonText: 'Update',
                ),
                SizedBox(height: 5),
                MyCardTextFormWithButton(
                  controller: settingsCtrl.ptvApiKeyController,
                  labelTextFormField: 'PTV API Key',
                  onPressedButton: () => settingsCtrl.saveSettings('ptvApiKey'),
                  buttonText: 'Update',
                ),
                SizedBox(height: 5),
                MyCardTextFormWithButton(
                  controller: settingsCtrl.ptvProxyBaseController,
                  labelTextFormField: 'PTV Proxy Base',
                  onPressedButton: () => settingsCtrl.saveSettings('ptvProxyBase'),
                  buttonText: 'Update',
                ),
                SizedBox(height: 5),
                MyCardTextFormWithButton(
                  controller: settingsCtrl.eControlLinkController,
                  labelTextFormField: 'E Control Link',
                  onPressedButton: () => settingsCtrl.saveSettings('eControlLink'),
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

