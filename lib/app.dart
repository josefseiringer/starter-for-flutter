
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../utils/sample_routes.dart';
import '../../ui/pages/login_view.dart';

class AppwriteApp extends StatelessWidget {
  const AppwriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Appwrite StarterKit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: LoginPage.namedRoute,
      getPages: SampleRouts.samplePages,
    );
  }
}
