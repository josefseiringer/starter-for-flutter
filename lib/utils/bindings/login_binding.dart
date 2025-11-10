import 'package:get/get.dart';
import '../../data/controller/login_controller.dart';

class LoginBinding extends Bindings {
    
    @override
    void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    }
    
}

class PermanentLoginBindings extends Bindings {
  
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController(), permanent: true);
  }

}
