import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/routes/app_routes.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    // Start animation
    _controller.forward();

    // Navigate to intro screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.intro); // Change to intro route
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade100,
                  Colors.green.shade300,
                  Colors.green.shade500,
                ],
                stops: [0.0, 0.5 + _controller.value * 0.2, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo dengan animasi
                  Center(
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: RotationTransition(
                            turns: _rotationAnimation,
                            child: Container(
                              height: 80,
                              width: 80,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.eco_rounded,
                                size: 50,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Teks Harvest - Guard dengan animasi
                        AnimatedOpacity(
                          opacity: _controller.value,
                          duration: const Duration(milliseconds: 800),
                          child: const Text(
                            'Harvest - Guard',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Sub text
                        FadeTransition(
                          opacity: _controller,
                          child: const Text(
                            'Proteksi Tanaman Padi Anda',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Teks "Developed by" dengan animasi
                  FadeTransition(
                    opacity: _controller,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Developed by',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),

                  // Nama developer dengan animasi
                  FadeTransition(
                    opacity: _controller,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 32.0),
                      child: Text(
                        'Bahrudin Ayub',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
