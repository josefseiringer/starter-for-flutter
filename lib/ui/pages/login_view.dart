import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  static const String namedRoute = '/login-page';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var logCtrl = controller;
    var whiteOpacity50 = Colors.white.withAlpha(50);
    var whiteOpacity100 = Colors.white.withAlpha(100);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Responsive Hintergrundbild
          Image.asset(
            'assets/mazdaCX60.png',
            fit: BoxFit.cover,
          ),
          // Durchscheinender Container mit TextFormFields
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: whiteOpacity50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: whiteOpacity50,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Email Field
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: whiteOpacity100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: whiteOpacity100,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: whiteOpacity100,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: whiteOpacity100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: whiteOpacity100,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: whiteOpacity100,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 20),

                      // Username Field
                      Obx(
                        () => logCtrl.isSignIn.value
                            ? TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  filled: true,
                                  fillColor: whiteOpacity100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: whiteOpacity100,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: whiteOpacity100,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.text,
                              )
                            : const SizedBox.shrink(),
                      ),
                      Obx(
                        () => logCtrl.isSignIn.value
                            ? const SizedBox(height: 20)
                            : const SizedBox.shrink(),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: whiteOpacity100),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Obx(() => logCtrl.isSignIn.value
                            ? TextButton.icon(
                                onPressed: () {},
                                label: Text(
                                  'SignIn',
                                  style: TextStyle(
                                    color: Colors.grey.shade900,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.app_registration,
                                  color: Colors.grey.shade900,
                                  size: 30,
                                ),
                              )
                            : TextButton.icon(
                                onPressed: () {},
                                label: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.grey.shade900,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.login,
                                  color: Colors.grey.shade900,
                                  size: 30,
                                ))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
