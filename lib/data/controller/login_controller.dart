import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../data/repository/appwrite_repository.dart';
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
    _checkInput();
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
    _checkInput();
    var email = emailController.text.trim();
    var password = passwordController.text.trim();
    _logData = await _appwriteRepository.login(email, password);
    var result = _logData.response;
    szUserId(result['userId']);
    if(_logData.status != 200){
      Get.snackbar('Error', 'Login failed: ${result['error']}',
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          colorText: const Color.fromRGBO(255, 255, 255, 1));
      return;
    }
    //go to HomePage and Display List data
    await Get.offAndToNamed(ListPage.namedRoute);
    _clearInputFields();
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

  void _checkInput() {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email',
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          colorText: const Color.fromRGBO(255, 255, 255, 1));
      return;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your password',
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          colorText: const Color.fromRGBO(255, 255, 255, 1));
      return;
    }
    if (isSignIn.value && nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name',
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          colorText: const Color.fromRGBO(255, 255, 255, 1));
      return;
    }
  }

  void _clearInputFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    isSignIn(false);
  }
}
