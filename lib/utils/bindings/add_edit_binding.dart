import 'package:get/get.dart';
import '../../data/controller/add_edit_controller.dart';

class AddEditBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<AddEditController>(() => AddEditController());
    }
}

class PermanentAddEditBinding extends Bindings {
    @override
    void dependencies() {
    Get.put<AddEditController>(AddEditController(), permanent: true);
    }
}
