import 'package:get/get.dart';
import '../../data/controller/graph_controller.dart';

class GraphBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<GraphController>(() => GraphController());
    }
}

class PermanentGraphBinding extends Bindings {
    @override
    void dependencies() {
    Get.put<GraphController>(GraphController(), permanent: true);
    }
}
