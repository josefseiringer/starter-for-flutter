import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/repository/appwrite_repository.dart';
import '../../ui/components/custom_numeric_keyboard.dart';
import '../../ui/pages/settings_view.dart';
import '../../utils/extensions/static_helper.dart';
import '../../ui/pages/list_view.dart';
import '../models/log.dart';

class LoginController extends GetxController {
  final headerText = 'Login Page'.obs;
  final isSignIn = false.obs;
  final szUserId = ''.obs;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late AppwriteRepository _appwriteRepository;
  late Log _logData;

  @override
  void onInit() {
    _logData = Log(date: '', status: 0, method: '', path: '', response: {});
    _appwriteRepository = AppwriteRepository();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  void signUp() async {
    if (!_checkInput()) return; // Beende bei ungültigen Eingaben
    var email = emailController.text.trim();
    var password = passwordController.text.trim();
    var name = nameController.text.trim();
    await _appwriteRepository.signUp(email, password, name).then((user) {
      _logData = user;
      print('User registered: ${user.response}');
      _clearInputFields();
      isSignIn(false);
      Get.snackbar('Success', 'User registered successfully',
          backgroundColor: const Color.fromARGB(255, 0, 255, 0),
          colorText: const Color.fromRGBO(255, 255, 255, 1));
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to register user: $error',
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          colorText: const Color.fromRGBO(255, 255, 255, 1));
    });
  }

  void login() async {
    if (!_checkInput()) return; // Beende bei ungültigen Eingaben
    
    // Zeige Loading-Indicator
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    
    try {
      var email = emailController.text.trim();
      var password = passwordController.text.trim();
      _logData = await _appwriteRepository.login(email, password);
      var result = _logData.response;
      
      // Schließe Loading-Dialog
      Get.back();
      
      // Erfolgreicher Login
      if(_logData.status == 200){
        szUserId(result['userId']);
        //go to HomePage and Display List data
        await Get.offAndToNamed(ListPage.namedRoute);
        _clearInputFields();
      } else {
        // Login-Fehler (falsche Credentials, etc.)
        print('Login failed: ${result['error']}');
        Get.snackbar('Error', 'Login failed: ${result['error']}',
            backgroundColor: const Color.fromARGB(255, 255, 0, 0),
            colorText: const Color.fromRGBO(255, 255, 255, 1),
            duration: const Duration(seconds: 5));
      }
    } catch (e) {
      // Schließe Loading-Dialog bei Fehler
      Get.back();
      print('Login exception: $e');
      
      // Spezifischere Fehlerbehandlung
      String errorMessage;
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Connection failed. Please check your network.';
      } else {
        errorMessage = 'Login failed. Please try again.';
      }
      
      Get.snackbar('Error', errorMessage,
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          colorText: const Color.fromRGBO(255, 255, 255, 1),
          duration: const Duration(seconds: 5));
    }
  }

  void logout() async {
    await _appwriteRepository.logout();
    _clearInputFields();
    szUserId('');
    isSignIn(false);
    Get.snackbar('Success', 'Logged out successfully',
        backgroundColor: const Color.fromARGB(255, 0, 255, 0),
        colorText: const Color.fromRGBO(255, 255, 255, 1));
  }

  bool _checkInput() {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email',
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          colorText: const Color.fromRGBO(255, 255, 255, 1));
      return false;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your password',
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          colorText: const Color.fromRGBO(255, 255, 255, 1));
      return false;
    }
    if (isSignIn.value && nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name',
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          colorText: const Color.fromRGBO(255, 255, 255, 1));
      return false;
    }
    return true;
  }

  void _clearInputFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    isSignIn(false);
  }
  //popup to change settings
  void switchEingangPrf() {
    String inputValue = '';
    Get.defaultDialog(
      title: 'Pin Nummer',
      content: Container(
        width: 350,
        height: 350,
        color: Colors.white,
        child: CustomNumericKeyboard(
          onValueChanged: (value) {
            inputValue = value;
          },
        ),
      ),
      cancel: TextButton(
        child: const Text('Cancel'),
        onPressed: () {
          Get.back();
        },
      ),
      confirm: TextButton(
        child: const Text('OK'),
        onPressed: () {
          DateTime now = DateTime.now();
          String currentDayMonth = DateFormat('ddMM').format(now);
          // Handle the input value here
          if (inputValue == currentDayMonth) {
            Get.back();
            Get.offAndToNamed(SettingsPage.namedRoute);
          } else {
            Get.back();
            StaticHelper.kDisplaySnackBarRed('Falsches Passwort!');
          }
        },
      ),
    );
  }
}
