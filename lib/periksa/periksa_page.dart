import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/periksa/periksa_controller.dart';
import 'dart:math' as math;

class PeriksaScreen extends StatefulWidget {
  const PeriksaScreen({super.key});

  @override
  State<PeriksaScreen> createState() => _PeriksaScreenState();
}

class _PeriksaScreenState extends State<PeriksaScreen>
    with SingleTickerProviderStateMixin {
  late final PeriksaController controller;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller
    controller = Get.put(PeriksaController());

    // Setup animasi
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Mulai animasi
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background dengan efek gradient dan elemen dekoratif
          _buildAnimatedBackground(),

          // Konten utama
          SafeArea(
            child: Column(
              children: [
                // App Bar custom
                _buildCustomAppBar(),

                // Konten utama dengan scroll
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),

                          // Judul utama dengan animasi
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _fadeInAnimation.value,
                                child: Transform.translate(
                                  offset: Offset(0, _slideAnimation.value),
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.green.shade200.withOpacity(0.5),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Periksa Kesehatan Padimu',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Ilustrasi
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: child,
                              );
                            },
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.eco_rounded,
                                      size: 120,
                                      color: Colors.green.shade300,
                                    ),
                                    Positioned(
                                      top: 50,
                                      right: 45,
                                      child: Icon(
                                        Icons.search,
                                        size: 60,
                                        color: Colors.green.shade700
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Subtitle
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final delayedOpacity =
                                  _animationController.value > 0.3
                                      ? (((_animationController.value - 0.3) /
                                                  0.7) *
                                              1.0)
                                          .clamp(0.0, 1.0)
                                      : 0.0;

                              return Opacity(
                                opacity: delayedOpacity,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - delayedOpacity)),
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 20,
                                        color: Colors.green.shade700,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Panduan Scanning',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Pastikan foto dengan jelas di bagian daun padi untuk hasil deteksi optimal',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Tombol Ambil Foto
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final delayedOpacity =
                                  _animationController.value > 0.4
                                      ? (((_animationController.value - 0.4) /
                                                  0.6) *
                                              1.0)
                                          .clamp(0.0, 1.0)
                                      : 0.0;

                              return Opacity(
                                opacity: delayedOpacity,
                                child: Transform.translate(
                                  offset: Offset(0, 30 * (1 - delayedOpacity)),
                                  child: child,
                                ),
                              );
                            },
                            child: GestureDetector(
                              onTap: () => controller.takePhoto(),
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade500,
                                      Colors.green.shade700,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.shade300
                                          .withOpacity(0.5),
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Ambil Foto',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Divider dengan "atau"
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final delayedOpacity =
                                  _animationController.value > 0.5
                                      ? (((_animationController.value - 0.5) /
                                                  0.5) *
                                              1.0)
                                          .clamp(0.0, 1.0)
                                      : 0.0;

                              return Opacity(
                                opacity: delayedOpacity,
                                child: child,
                              );
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'atau',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Tombol Pilih dari Galeri
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final delayedOpacity =
                                  _animationController.value > 0.6
                                      ? (((_animationController.value - 0.6) /
                                                  0.4) *
                                              1.0)
                                          .clamp(0.0, 1.0)
                                      : 0.0;

                              return Opacity(
                                opacity: delayedOpacity,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - delayedOpacity)),
                                  child: child,
                                ),
                              );
                            },
                            child: GestureDetector(
                              onTap: () => controller.pickFromGallery(),
                              child: Container(
                                width: double.infinity,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                    width: 1.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.photo_library_rounded,
                                          size: 24,
                                          color: Colors.green.shade600,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Pilih dari Galeri',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Format: JPG, JPEG, PNG',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom App Bar dengan efek transparan
  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back button dengan efek glassmorphism
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Info icon dengan efek glassmorphism
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  _showInfoDialog();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.help_outline_rounded,
                    size: 20,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Animated Background dengan elemen dekoratif
  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.green.shade50,
                Colors.white,
                Colors.white,
              ],
              stops: const [0.0, 0.3, 1.0],
            ),
          ),
        ),

        // Decorative top blob
        Positioned(
          top: -80,
          right: -50,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.green.shade200.withOpacity(0.6),
                  Colors.green.shade200.withOpacity(0.0),
                ],
                stops: const [0.2, 1.0],
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Decorative bottom blob
        Positioned(
          bottom: 100,
          left: -30,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.green.shade200.withOpacity(0.4),
                  Colors.green.shade200.withOpacity(0.0),
                ],
                stops: const [0.2, 1.0],
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Decorative elements
        for (int i = 0; i < 5; i++)
          Positioned(
            top: 150 + (i * 120),
            left: (i % 2 == 0) ? 20 : null,
            right: (i % 2 == 0) ? null : 20,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final delayedStart = 0.1 * i;
                final localProgress =
                    ((_animationController.value - delayedStart) /
                            (1 - delayedStart))
                        .clamp(0.0, 1.0);

                return Opacity(
                  opacity: localProgress * 0.3,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      20 * (1 - localProgress),
                    ),
                    child: Icon(
                      Icons.eco,
                      size: 20 + (i * 2),
                      color: Colors.green.shade300.withOpacity(0.3),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _showInfoDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.tips_and_updates_rounded,
                      color: Colors.green.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Tips Foto yang Baik',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTipItem(
                Icons.brightness_5_rounded,
                'Foto dengan pencahayaan yang cukup',
              ),
              const SizedBox(height: 10),
              _buildTipItem(
                Icons.center_focus_strong_rounded,
                'Fokus pada bagian daun yang menunjukkan gejala',
              ),
              const SizedBox(height: 10),
              _buildTipItem(
                Icons.crop_rounded,
                'Hindari bayangan atau jari di foto',
              ),
              const SizedBox(height: 10),
              _buildTipItem(
                Icons.filter_rounded,
                'Jangan menggunakan filter kamera',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text(
                  'Mengerti',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.green.shade600,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
