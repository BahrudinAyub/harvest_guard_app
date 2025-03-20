import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Base class untuk semua halaman penyakit
abstract class BaseDiseaseDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final List<String> treatments;
  final List<String> preventions;

  const BaseDiseaseDetailPage({
    required this.title,
    required this.description,
    required this.treatments,
    required this.preventions,
  });

  @override
  Widget build(BuildContext context) {
    // Dapatkan argumen dari navigasi
    final args = Get.arguments as Map<String, dynamic>;
    final prediction = args['prediction'] as Map<String, dynamic>;
    final imagePath = args['imagePath'] as String?;
    final confidence = (prediction['confidence'] as double) * 100;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tampilkan gambar jika tersedia dengan design yang lebih baik
            if (imagePath != null)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.photo_camera, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Hasil Scan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan nama penyakit dan tingkat keyakinan
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          prediction['disease'] as String,
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: confidence > 80 ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${confidence.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Deskripsi penyakit
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(description),
                  
                  SizedBox(height: 24),
                  
                  // Cara penanganan
                  if (treatments.isNotEmpty) ...[
                    Text(
                      'Penanganan',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 8),
                    ...treatments.map((treatment) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(child: Text(treatment)),
                        ],
                      ),
                    )).toList(),
                    SizedBox(height: 24),
                  ],
                  
                  // Cara pencegahan
                  Text(
                    'Pencegahan',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 8),
                  ...preventions.map((prevention) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.shield, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(child: Text(prevention)),
                      ],
                    ),
                  )).toList(),
                  
                  SizedBox(height: 24),
                  
                  // Tombol untuk membagikan hasil atau mencari informasi lebih lanjut
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.share),
                          label: Text('Bagikan Hasil'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            // TODO: Implementasi fungsi berbagi
                            Get.snackbar(
                              'Bagikan',
                              'Fitur berbagi akan segera tersedia',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.info_outline),
                          label: Text('Info Lanjut'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            // TODO: Implementasi fungsi info lanjut
                            Get.snackbar(
                              'Info Lanjut',
                              'Fitur informasi lanjutan akan segera tersedia',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () {
          // Kembali ke halaman scan
          Get.until((route) => route.settings.name == '/');
        },
        tooltip: 'Scan Baru',
      ),
    );
  }
}