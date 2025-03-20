import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/components/scan_history_card.dart';
import 'package:harvest_guard_app/dashboard/dashboard_controller.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan greeting dan avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Greeting text dengan nama user
                  Obx(() => Text(
                        'Hallo, ${controller.userName.value}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )),

                  // Avatar image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFD966),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Periksa kesehatan text
              const Text(
                'Periksa kesehatan padimu sekarang!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 16),

              // Periksa kesehatan card - hanya navigasi ke PeriksaScreen
              GestureDetector(
                onTap: controller.startScanning,
                child: Image.asset(
                  'assets/images/main_button.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // Riwayat kesehatan section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat kesehatan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Selengkapnya text button
                  GestureDetector(
                    onTap: controller.navigateToScanHistoryDetail,
                    child: const Text(
                      'Selengkapnya',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Riwayat scan list
              Expanded(
                child: Obx(() {
                  final scanHistory = controller.modelController.scanHistoryList;

                  if (scanHistory.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada riwayat pemeriksaan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  // Tampilkan 3 history terbaru saja
                  final recentHistory = scanHistory.length > 3
                      ? scanHistory.sublist(0, 3)
                      : scanHistory;

                  return ListView.builder(
                    itemCount: recentHistory.length,
                    itemBuilder: (context, index) {
                      final item = recentHistory[index];
                      return ScanHistoryCard(
                        imagePath: item.imagePath,
                        diseaseResult: item.diseaseResult,
                        timestamp: item.timestamp,
                        confidence: item.confidence,
                        diseaseId: item.diseaseId,
                        scanHistoryItem: item, // Menambahkan item scan history untuk fungsi hapus
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.startScanning,
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
        tooltip: 'Periksa Baru',
      ),
    );
  }
}