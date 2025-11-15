import 'package:get/get.dart';
import '../../data/controller/sprit_controller.dart';

class SpritBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<SpritController>(() => SpritController());
    }
}

class PermanentSpritBinding extends Bindings {
    @override
    void dependencies() {
    Get.put<SpritController>(SpritController(), permanent: true);
    }
}
