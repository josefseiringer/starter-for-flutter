import 'package:get/get.dart';
import '../../data/controller/list_controller.dart';

class ListBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<ListController>(() => ListController());
    }
}

class PermanentListBinding extends Bindings {
    @override
    void dependencies() {
    Get.put<ListController>(ListController(), permanent: true);
    }
} 
