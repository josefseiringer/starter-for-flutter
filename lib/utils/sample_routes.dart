
import 'package:get/get.dart';

import '../ui/pages/graph_view.dart';
import '../ui/pages/login_view.dart';
import '../ui/pages/list_view.dart';
import '../ui/pages/add_edit_view.dart';
import '../ui/pages/sprit_view.dart';
import '../utils/bindings/graph_binding.dart';
import '../utils/bindings/login_binding.dart';
import '../utils/bindings/list_binding.dart';
import '../utils/bindings/add_edit_binding.dart';
import 'bindings/sprit_binding.dart';

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
    // Add Edit Page
    GetPage(
      name: AddEditPage.namedRoute,
      binding: AddEditBinding(),
      page: () => const AddEditPage(),
    ),
    GetPage(
      name: GraphPage.namedRoute,
      binding: GraphBinding(),
      page: () => const GraphPage(),
    ),
    // E-Control Page
    GetPage(
      name: SpritPage.namedRoute,
      binding: SpritBinding(),
      page: () => const SpritPage(),
    ),

  ];
}
