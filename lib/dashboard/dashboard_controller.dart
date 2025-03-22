import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/periksa/model_controller.dart';
import 'package:harvest_guard_app/routes/app_routes.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // User name state
  var userName = "Petani".obs;

  // Reference to ModelController for scan history
  late final ModelController modelController;

  // Animation controller
  late AnimationController animationController;

  // Animation status
  var animationCompleted = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get ModelController instance
    if (!Get.isRegistered<ModelController>()) {
      Get.put(ModelController());
    }
    modelController = Get.find<ModelController>();

    // Initialize animation controller - hanya jalankan sekali
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Durasi total animasi
    );

    // Tambahkan listener untuk memastikan nilai dalam batas
    animationController.addListener(() {
      // Pastikan nilai animasi selalu dalam rentang 0.0 - 1.0
      if (animationController.value < 0.0 || animationController.value > 1.0) {
        animationController.value = animationController.value.clamp(0.0, 1.0);
      }
    });

    // Mulai animasi sekali ketika halaman dimuat
    // Pastikan animasi hanya jalan sekali dan tidak repeat
    animationController.forward().then((_) {
      animationCompleted.value = true;
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  // Fungsi untuk memulai pemindaian dan navigasi ke PeriksaScreen
  void startScanning() {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Animasi transisi custom
    Get.toNamed(
      AppRoutes.periksa,
    );
  }

  // Navigate to scan history detail screen
  void navigateToScanHistoryDetail() {
    // Haptic feedback
    HapticFeedback.lightImpact();

    Get.toNamed(
      AppRoutes.scanHistory,
    );
  }

  // Open history item detail
  void openHistoryDetail(dynamic historyItem) {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Implement detail view navigation
    Get.toNamed(
      '${AppRoutes.scanHistory}/${historyItem.id}',
      arguments: historyItem,
    );
  }

  // Switch user profile
  void switchUserProfile() {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Placeholder untuk fitur profil multiple
    final profiles = ["Petani", "Ahmad", "Budi", "Citra"];
    final currentIndex = profiles.indexOf(userName.value);
    final nextIndex = (currentIndex + 1) % profiles.length;

    userName.value = profiles[nextIndex];
  }

  // Reset animasi ketika halaman muncul kembali
  void resetAnimation() {
    animationController.reset();
    animationController.forward();
  }
}
