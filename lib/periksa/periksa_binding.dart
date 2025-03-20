import 'package:get/get.dart';
import 'periksa_controller.dart';

class PeriksaBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PeriksaController());
  }
}