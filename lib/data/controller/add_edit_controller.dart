import 'package:appwrite_flutter_tank_app_101125/data/repository/appwrite_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../ui/pages/list_view.dart';
import '../../data/repository/location_repository.dart';
import '../models/list_model.dart';
import '../models/log.dart';

class AddEditController extends GetxController {
  final isEditMode = false.obs;
  late TextEditingController dateController;
  late TextEditingController odometerController;
  late TextEditingController litersController;
  late TextEditingController pricePerLiterController;
  late TextEditingController addressController;
  final LocationProvider _locationProvider = LocationProvider();
  final AppwriteRepository _appwriteRepository = AppwriteRepository();
  late Position _currentPosition;
  late Log _logData;
  final tankModelItem = ListModel(
          id: '',
          userId: '',
          date: '',
          odometer: 0,
          liters: 0,
          pricePerLiter: 0,
          location: '')
      .obs;

  final formKey = GlobalKey<FormState>().obs;

  @override
  void onInit() {
    _logData = Log(date: '', status: 0, method: '', path: '', response: {});
    if (Get.arguments != null && Get.arguments is ListModel) {
      tankModelItem(Get.arguments as ListModel);
      isEditMode(true);
      _fillTextFieldsForEdit();
    } else {
      isEditMode(false);
      dateController = TextEditingController();
      odometerController = TextEditingController();
      litersController = TextEditingController();
      pricePerLiterController = TextEditingController();
      addressController = TextEditingController();
      getInitialDate();
      _getLocation();
    }
    super.onInit();
  }

  @override
  void onReady() async {
    //await _getLocation();
  }

  @override
  void onClose() {
    dateController.dispose();
    odometerController.dispose();
    litersController.dispose();
    pricePerLiterController.dispose();
    addressController.dispose();
  }

  clearTextFields() {
    dateController.clear();
    odometerController.clear();
    litersController.clear();
    pricePerLiterController.clear();
    addressController.clear();
  }

  Future<void> _getLocation() async {
    // Implement location fetching logic here
    _currentPosition = await _locationProvider.getCurrentPosition();
    if (_currentPosition.latitude != 0.0 && _currentPosition.longitude != 0.0) {
      print(
          'Current Position: Lat: ${_currentPosition.latitude}, Lng: ${_currentPosition.longitude}');
      // You can use _currentPosition to update locationController if needed
      _logData = await _locationProvider.getAddressLocationLogData({
        'lat': _currentPosition.latitude,
        'lng': _currentPosition.longitude
      });
      // Handle _logData as needed in add Mode
      if (isEditMode.isFalse && _logData.status == 200) {
        Map<String, dynamic> mapOfAddressfromPosition =
            _logData.response['locations'][0]
                ['address']; //get response address of position
        if (mapOfAddressfromPosition.isNotEmpty) {
          addressController.text =
              '${mapOfAddressfromPosition['street'].toString()} ${mapOfAddressfromPosition['houseNumber'].toString()}, ${mapOfAddressfromPosition['postalCode'].toString()} ${mapOfAddressfromPosition['city'].toString()}';
        }
      } else {
        print('Error fetching address: ${_logData.response.toString()}');
      }
      addressController.text = await _locationProvider.getNearbyLocation({
        'lat': _currentPosition.latitude,
        'lng': _currentPosition.longitude
      });
    } else {
      print('Could not fetch location.');
      return;
    }
  }

  void _fillTextFieldsForEdit() {
    dateController = TextEditingController(text: tankModelItem.value.date);
    odometerController =
        TextEditingController(text: tankModelItem.value.odometer.toString());
    litersController =
        TextEditingController(text: tankModelItem.value.liters.toString());
    pricePerLiterController = TextEditingController(
        text: tankModelItem.value.pricePerLiter.toString());
    addressController =
        TextEditingController(text: tankModelItem.value.location);
  }

  void goToList() {
    Get.offAndToNamed(ListPage.namedRoute);
  }

  Future<void> getDateFromDateTimePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      dateController.text = formattedDate;
    }
  }

  void getInitialDate() {
    var currentDate = DateTime.now();
    dateController.text =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
  }

  Future<void> saveOrUpdateEntry() async {
    if (formKey.value.currentState!.validate()) {
      // Perform save or update operation
      if (isEditMode.value) {
        // Update existing entry
        await _updateTankItem();
        print('Updating entry... ${_logData.response.toString()}');
      } else {
        // Save new entry
        await _saveNewStop();
      }
      // After saving or updating, navigate back to the list view
      goToList();
    }
  }

  Future<String> _getUserId() async {
    Map<String, dynamic> dataSession =
        (await _appwriteRepository.getCurrentSession()).toMap();
    print('Current Session: $dataSession');
    return dataSession['userId'];
  }

  Future<void> _updateTankItem() async {
    var szDate = dateController.text;
    var odometer = odometerController.text;
    var liters = litersController.text;
    var pricePerLiter = pricePerLiterController.text;
    var address = addressController.text;
    _logData =
        await _appwriteRepository.updateDocument(tankModelItem.value.id, {
      'date': szDate,
      'odometer': odometer,
      'liters': liters,
      'pricePerLiter': pricePerLiter,
      'location': address,
    });
    print('Updating entry... ${_logData.response.toString()}');
  }

  Future<void> _saveNewStop() async {
    var userId = await _getUserId();
    var szDate = dateController.text;
    var odometer = odometerController.text;
    var liters = litersController.text;
    var pricePerLiter = pricePerLiterController.text;
    var address = addressController.text;
    _logData = await _appwriteRepository.createDocument({
      'userId': userId,
      'date': szDate,
      'odometer': odometer,
      'liters': liters,
      'pricePerLiter': pricePerLiter,
      'location': address,
    });
    print('Saving new entry... ${_logData.response.toString()}');
  }
}
