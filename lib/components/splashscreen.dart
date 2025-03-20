import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tunggu selama 3 detik kemudian navigasi ke Dashboard dengan AppRoutes
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(
          AppRoutes.dashboard); // Menggunakan konstanta route dari AppRoutes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Spacer untuk menjaga tampilan di tengah
            const Spacer(flex: 2),

            // Logo tanaman menggunakan Image.asset
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/plant.png',
                    height: 60,
                    width: 60,
                  ),

                  const SizedBox(height: 20),

                  // Teks Harvest - Guard
                  const Text(
                    'Harvest - Guard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Spacer untuk mendorong "Developed by" ke bagian bawah
            const Spacer(flex: 3),

            // Teks "Developed by"
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Developed by',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),

            // Nama developer
            const Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                'Bahrudin Ayub',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
