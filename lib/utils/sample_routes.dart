

import 'package:get/get.dart';

import '../ui/pages/login_view.dart';
import '../utils/bindings/login_binding.dart';

class SampleRouts {
  static final samplePages = [
    GetPage(
      name: LoginPage.namedRoute,
      binding: LoginBinding(),
      page: () => const LoginPage(),
    ),
  ];
}
