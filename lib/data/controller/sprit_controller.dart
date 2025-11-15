import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../../ui/pages/list_view.dart';
import '../models/log.dart';
import '../../data/repository/gas_repository.dart';
import '../../data/models/e_control_model.dart';

class SpritController extends GetxController {
  final isloading = false.obs;
  final selectedFuel = 'DIE'.obs;

  final headNameFuel = 'Tankstellen Diesel'.obs;
  final GasRepository _gasRepository = GasRepository();
  late Log _logData;
  final listEControl = <EControlModel>[].obs;

  @override
  void onInit() {
    switchGas('DIE');
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}


  void onBackPressed() {
    Get.offAndToNamed(ListPage.namedRoute);
  }

  Future<void> switchGas(String s) async {
    isloading(true);
    selectedFuel.value = s;
    _logData = await _gasRepository.switchGas(s);
    if(_logData.status == 200){
      var mapData = _logData.response;
      // Process mapData as needed
      print( 'Gas switch successful: $mapData' );
      listEControl.clear();
      if (mapData.containsKey('body')) {
        var bodyData = mapData['body'];
        if (bodyData is List) {
          List<dynamic> listResult = bodyData;
          if (listResult.isNotEmpty) {
            // Nur die ersten 5 Elemente verarbeiten
            int maxElements = listResult.length > 5 ? 5 : listResult.length;
            for (int i = 0; i < maxElements; i++) {
              var element = listResult[i];
              if (element is Map<String, dynamic>) {
                listEControl.add(EControlModel.fromMap(element));
              }
            }
          }
        } else {
          print('Body data is not a List: ${bodyData.runtimeType}');
        }
      }
        
      if (s == 'DIE') {
        headNameFuel.value = 'Tankstellen Diesel';
      } else {
        headNameFuel.value = 'Tankstellen Super';
      }
    } else {
      Get.snackbar(
        'Fehler',
        'Kraftstoffart konnte nicht gewechselt werden: ${_logData.response['error']}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isloading(false);
    update();
  }

  void goToMap(EControlModel eControl) async {
    final latitude = eControl.location.latitude;
    final longitude = eControl.location.longitude;
    
    try {
      Uri uri;
      
      // iOS - Apple Maps
      if (Platform.isIOS) {
        uri = Uri.parse('maps://app?daddr=$latitude,$longitude');
        if (!await canLaunchUrl(uri)) {
          // Fallback zu Google Maps im Browser
          uri = Uri.parse('https://maps.google.com/maps?daddr=$latitude,$longitude');
        }
      } 
      // Android - Google Maps
      else if (Platform.isAndroid) {
        uri = Uri.parse('google.navigation:q=$latitude,$longitude');
        if (!await canLaunchUrl(uri)) {
          // Fallback zu Google Maps im Browser
          uri = Uri.parse('https://maps.google.com/maps?daddr=$latitude,$longitude');
        }
      } 
      // Web/Desktop - Google Maps im Browser
      else {
        uri = Uri.parse('https://maps.google.com/maps?daddr=$latitude,$longitude');
      }
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Fehler',
          'Navigation konnte nicht geöffnet werden',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error launching map: $e');
      Get.snackbar(
        'Fehler',
        'Navigation konnte nicht geöffnet werden: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}