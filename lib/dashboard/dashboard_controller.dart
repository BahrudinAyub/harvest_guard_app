import 'package:get/get.dart';
import 'package:harvest_guard_app/periksa/model_controller.dart';
import 'package:harvest_guard_app/routes/app_routes.dart';


class DashboardController extends GetxController {
  // User name state
  var userName = "Petani".obs;
  
  // Reference to ModelController for scan history
  late final ModelController modelController;
  
  @override
  void onInit() {
    super.onInit();
    
    // Get ModelController instance
    if (!Get.isRegistered<ModelController>()) {
      Get.put(ModelController());
    }
    modelController = Get.find<ModelController>();
  }

  // Fungsi untuk memulai pemindaian dan navigasi ke PeriksaScreen
  void startScanning() {
    // Navigasi ke PeriksaScreen menggunakan AppRoutes
    Get.toNamed(AppRoutes.periksa);
  }
  
  // Navigate to scan history detail screen
  void navigateToScanHistoryDetail() {
    Get.toNamed(AppRoutes.scanHistory);
  }
}