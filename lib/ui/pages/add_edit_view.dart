import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/controller/add_edit_controller.dart';

class AddEditPage extends GetView<AddEditController> {
  static const String namedRoute = '/add-edit-page';
  const AddEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    var editCtrl = controller;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => editCtrl.goToList(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Obx(
              () => Text(controller.isEditMode.value
                  ? 'Eintrag bearbeiten'
                  : 'Eintrag hinzufügen'),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => editCtrl.goToList(),
                icon: const Icon(Icons.list),
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/mazdaCX60.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              children: [
                Text(
                  editCtrl.isEditMode.value
                      ? 'Edit Mode - Form goes here ${editCtrl.addressController.text}'
                      : 'Add Mode - Form goes here',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Add your form fields here
                // Button save Update
                ElevatedButton(
                  onPressed: () {
                    // Save or Update logic here
                  },
                  child: Text(
                    editCtrl.isEditMode.value ? 'Update' : 'Save',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
