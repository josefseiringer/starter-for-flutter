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
              () => Text(editCtrl.isEditMode.value
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
          body: Stack(
            alignment: AlignmentGeometry.center,
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/mazdaCX60.png',
                fit: BoxFit.cover,
              ),
              Form(
                key: editCtrl.formKey.value,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: ListView(
                    children: [
                      SizedBox(height: 20),
                      // Add your form fields here
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          editCtrl.getDateFromDateTimePicker(context);
                        },
                        controller: editCtrl.dateController,
                        decoration: const InputDecoration(
                          labelText: 'Datum',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte Datum eingeben';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: editCtrl.odometerController,
                        decoration: const InputDecoration(
                          labelText: 'Kilometerstand',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte Kilometerstand eingeben';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Bitte eine gültige Zahl eingeben';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: editCtrl.litersController,
                        decoration: const InputDecoration(
                          labelText: 'Liter',
                          border: OutlineInputBorder(),
                        ),
                        //keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte Liter eingeben';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Bitte eine gültige Zahl eingeben';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: editCtrl.pricePerLiterController,
                        decoration: const InputDecoration(
                          labelText: 'Preis pro Liter',
                          border: OutlineInputBorder(),
                        ),
                        //keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte Preis pro Liter eingeben';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Bitte eine gültige Zahl eingeben';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: editCtrl.addressController,
                        decoration: const InputDecoration(
                          labelText: 'Adresse',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte Adresse eingeben';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40),
                      // Button save Update
                      ElevatedButton(
                        onPressed: () {
                          // Save or Update logic here
                          editCtrl.saveOrUpdateEntry();
                        },
                        child: Text(
                          editCtrl.isEditMode.value ? 'Update' : 'Save',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
