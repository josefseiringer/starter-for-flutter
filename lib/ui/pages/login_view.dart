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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => logCtrl.switchEingangPrf(),
          icon: Icon(Icons.settings),
        ),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text('Login / Sign In'),
        centerTitle: true,
      ),
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
                      // header icon
                      IconButton(
                        onPressed: () => logCtrl.logout(),
                        icon: Obx(
                          () => logCtrl.isSignIn.value
                              ? Icon(Icons.app_registration,
                                  color: Colors.white, size: 80)
                              : Icon(Icons.login,
                                  color: Colors.white, size: 80),
                        ),
                      ),
                      // header Text
                      Obx(
                        () => Text(
                          logCtrl.isSignIn.value ? 'Sign In' : 'Login',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Email Field
                      _emailFormField(logCtrl, whiteOpacity100),
                      const SizedBox(height: 20),

                      // Password Field
                      _passwordFormField(logCtrl, whiteOpacity100),
                      const SizedBox(height: 20),

                      // Username Field
                      Obx(
                        () => logCtrl.isSignIn.value
                            ? _nameFormField(logCtrl, whiteOpacity100)
                            : const SizedBox.shrink(),
                      ),
                      Obx(
                        () => logCtrl.isSignIn.value
                            ? const SizedBox(height: 20)
                            : const SizedBox.shrink(),
                      ),
                      _logSignInButtonContainer(whiteOpacity100, logCtrl),
                      const SizedBox(height: 20),
                      Obx(
                        () => _switchLogiSignInText(logCtrl),
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

  TextButton _switchLogiSignInText(LoginController logCtrl) {
    return TextButton(
      onPressed: () {
        logCtrl.isSignIn.toggle();
      },
      child: logCtrl.isSignIn.value
          ? const Text(
              'Already have an account? Login',
              style: TextStyle(color: Colors.white),
            )
          : const Text(
              'Don\'t have an account? Sign In',
              style: TextStyle(color: Colors.white),
            ),
    );
  }

  Container _logSignInButtonContainer(
      Color whiteOpacity100, LoginController logCtrl) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: whiteOpacity100),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(
        () => logCtrl.isSignIn.value
            ? TextButton.icon(
                onPressed: () => logCtrl.signUp(),
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
                onPressed: () => logCtrl.login(),
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
                ),
              ),
      ),
    );
  }

  TextFormField _nameFormField(LoginController logCtrl, Color whiteOpacity100) {
    return TextFormField(
      controller: logCtrl.nameController,
      decoration: InputDecoration(
        labelText: 'Username',
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
      keyboardType: TextInputType.text,
    );
  }

  TextFormField _passwordFormField(
      LoginController logCtrl, Color whiteOpacity100) {
    return TextFormField(
      controller: logCtrl.passwordController,
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
    );
  }

  TextFormField _emailFormField(
      LoginController logCtrl, Color whiteOpacity100) {
    return TextFormField(
      controller: logCtrl.emailController,
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
    );
  }
}
