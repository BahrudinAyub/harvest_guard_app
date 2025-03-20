import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/periksa/periksa_controller.dart';


class PeriksaScreen extends StatelessWidget {
  const PeriksaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PeriksaController controller = Get.put(PeriksaController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Periksa Kesehatan Padi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Judul utama
              const Center(
                child: Text(
                  'Periksa Kesehatan\nPadimu Sekarang',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Subtitle
              const Center(
                child: Text(
                  'Foto di bagian daun padi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Ambil Foto (lingkaran hijau)
              GestureDetector(
                onTap: () => controller.takePhoto(),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ikon kamera dengan border putih
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.center_focus_strong_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Ambil Foto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                'atau',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Pilih dari Galeri
              GestureDetector(
                onTap: () => controller.pickFromGallery(),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih dari Galeri\n*JPG, JPEG, PNG',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(
                          Icons.insert_drive_file_outlined,
                          size: 30,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
