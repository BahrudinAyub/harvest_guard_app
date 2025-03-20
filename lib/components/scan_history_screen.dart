import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/components/scan_history_card.dart';
import 'package:harvest_guard_app/dashboard/dashboard_controller.dart';

class ScanHistoryScreen extends GetView<DashboardController> {
  const ScanHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemeriksaan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final scanHistory = controller.modelController.scanHistoryList;

          if (scanHistory.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64.0,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Belum ada riwayat pemeriksaan',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Lakukan pemeriksaan untuk melihat riwayat',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: scanHistory.length,
            itemBuilder: (context, index) {
              final item = scanHistory[index];
              
              // Menggunakan ScanHistoryCard dengan parameter scanHistoryItem
              return ScanHistoryCard(
                imagePath: item.imagePath,
                diseaseResult: item.diseaseResult,
                timestamp: item.timestamp,
                confidence: item.confidence,
                diseaseId: item.diseaseId,
                scanHistoryItem: item, // Menambahkan item untuk fungsi hapus
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.startScanning,
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
        tooltip: 'Periksa Baru',
      ),
    );
  }
}