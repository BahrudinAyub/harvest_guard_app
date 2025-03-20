// File: lib/components/scan_history_card.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/data/scan_history_model.dart';
import 'package:intl/intl.dart';
import 'package:harvest_guard_app/dashboard/dashboard_controller.dart';


class ScanHistoryCard extends StatelessWidget {
  final String imagePath;
  final String diseaseResult;
  final DateTime timestamp;
  final double confidence;
  final VoidCallback? onTap;
  final String? diseaseId;
  final ScanHistory? scanHistoryItem; // Tambahkan parameter untuk item ScanHistory
  
  const ScanHistoryCard({
    Key? key,
    required this.imagePath,
    required this.diseaseResult,
    required this.timestamp,
    required this.confidence,
    this.onTap,
    this.diseaseId,
    this.scanHistoryItem, // Parameter opsional untuk item yang akan dihapus
  }) : super(key: key);

  void _navigateToDetailPage() {
    // Jika ada onTap callback yang diberikan, gunakan itu
    if (onTap != null) {
      onTap!();
      return;
    }
    
    // Tentukan routeName berdasarkan diseaseResult
    String routeName;
    
    switch (diseaseResult) {
      case 'Hawar Daun Bakteri':
        routeName = '/hawar-daun';
        break;
      case 'Bercak Coklat':
        routeName = '/bercak-coklat';
        break;
      case 'Sehat':
        routeName = '/sehat';
        break;
      case 'Hispa':
        routeName = '/hispa';
        break;
      default:
        routeName = '/tidak-teridentifikasi';
        break;
    }
    
    // Siapkan data prediction untuk dikirim ke halaman detail
    final prediction = {
      'disease': diseaseResult,
      'confidence': confidence,
      'diseaseId': diseaseId ?? diseaseResult.toLowerCase().replaceAll(' ', '_'),
      'routeName': routeName,
    };
    
    // Navigasi ke halaman detail dengan argumen
    Get.toNamed(routeName, arguments: {
      'prediction': prediction,
      'imagePath': imagePath,
    });
  }

  // Fungsi untuk menghapus riwayat
  void _deleteHistoryItem() {
    if (scanHistoryItem == null) {
      print('Tidak dapat menghapus: scanHistoryItem is null');
      return;
    }

    // Tampilkan dialog konfirmasi
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus riwayat pemeriksaan ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Tutup dialog
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Tutup dialog
              Get.back();
              
              // Dapatkan controller dan hapus riwayat
              final dashboardController = Get.find<DashboardController>();
              dashboardController.modelController.deleteScanHistory(scanHistoryItem!);
              
              // Tampilkan pesan
              Get.snackbar(
                'Berhasil',
                'Riwayat pemeriksaan telah dihapus',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withOpacity(0.7),
                colorText: Colors.white,
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format the date and time
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');
    final date = dateFormat.format(timestamp);
    final time = timeFormat.format(timestamp);

    // Get status color based on disease result
    Color statusColor = Colors.green;
    if (diseaseResult != 'Sehat') {
      statusColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: _navigateToDetailPage,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Image thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      File(imagePath),
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Disease result
                            Expanded(
                              child: Text(
                                diseaseResult,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Status indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                diseaseResult == 'Sehat' ? 'Sehat' : 'Terinfeksi',
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        // Confidence
                        Text(
                          'Keyakinan: ${(confidence * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        // Date and time
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14.0,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              date,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Icon(
                              Icons.access_time,
                              size: 14.0,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              time,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Tombol hapus - hanya ditampilkan jika scanHistoryItem tersedia
              if (scanHistoryItem != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _deleteHistoryItem,
                        icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                        label: const Text(
                          'Hapus',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.0,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Colors.red, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}