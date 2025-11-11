

import 'package:get/get.dart';

import '../ui/pages/list_view.dart';
import '../ui/pages/login_view.dart';
import '../utils/bindings/login_binding.dart';
import './bindings/list_binding.dart';

class SampleRouts {

  static final samplePages = [
    // Login Page
    GetPage(
      name: LoginPage.namedRoute,
      binding: LoginBinding(),
      page: () => const LoginPage(),
    ),
    // List Page
    GetPage(
      name: ListPage.namedRoute,
      binding: ListBinding(),
      page: () => const ListPage(),
    ),

  ];
}
