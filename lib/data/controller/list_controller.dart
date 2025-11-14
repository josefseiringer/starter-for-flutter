import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/list_model.dart';
import '../models/log.dart';
import '../../ui/pages/graph_view.dart';
import '../../ui/pages/add_edit_view.dart';
import '../../ui/pages/login_view.dart';
import '../../data/repository/appwrite_repository.dart';

class ListController extends GetxController {
  final isloading = false.obs;
  final listTankModel = <ListModel>[].obs;
  final userName = 'No Name'.obs;
  final AppwriteRepository _appwriteRepository = AppwriteRepository();
  late Log _logData;

  @override
  void onInit() {
    _logData = Log(date: '', status: 0, method: '', path: '', response: {});
    _getListFromAppwrite();
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  void onBackPressed() async {
    await _appwriteRepository.logout();
    Get.offAndToNamed(LoginPage.namedRoute);
    Get.snackbar(
      'Login',
      'Logged out successfully',
      colorText: const Color.fromRGBO(255, 255, 255, 1),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    );
  }

  void _getListFromAppwrite() async {
    try {
      isloading(true);
      // Your code to fetch list from Appwrite goes here
      _logData = await _appwriteRepository.listDocuments();
      //print(_logData.response);
      if (_logData.status == 200) {
        listTankModel.clear();
        _logData.response['documents'].forEach((item) {
          var dataItem = item['data'];
          listTankModel.add(ListModel.fromMap(dataItem));
        });

        // Sortiere nach Datum absteigend (neueste zuerst)
        listTankModel.sort((a, b) {
          try {
            final dateA = DateTime.parse(a.date);
            final dateB = DateTime.parse(b.date);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0; // Bei Parse-Fehler keine Änderung
          }
        });

        print('List fetched: ${listTankModel.length} items');

        var currentUser = await _appwriteRepository.getCurrentUser();
        userName(currentUser.name ?? 'No Name');
      } else {
        print('Error fetching list: ${_logData.response.toString()}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isloading(false);
    }
  }

  void deleteItem(ListModel item) async {
    listTankModel.removeWhere((element) => element.id == item.id);
    _logData = await _appwriteRepository.deleteDocument(item.id);
    print('Item deleted: ${_logData.response.toString()}');
    update();
  }

  void addItem() {
    Get.offAndToNamed(AddEditPage.namedRoute);
  }

  void editItem(ListModel item) {
    Get.offAndToNamed(AddEditPage.namedRoute, arguments: item);
  }

  void goToChartView() {
    Get.offAndToNamed(GraphPage.namedRoute);
  }
}
