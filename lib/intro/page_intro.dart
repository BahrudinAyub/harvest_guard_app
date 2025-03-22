import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/routes/app_routes.dart';
import 'dart:math' as math;

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  // Controller untuk animasi
  late final AnimationController _backgroundAnimController;
  late final AnimationController _contentAnimController;

  // Halaman saat ini
  int _currentPage = 0;

  // Data halaman intro
  final List<IntroData> _introPages = [
    IntroData(
      title: 'Pilih Varietas Padi',
      description:
          'Pilih jenis padi yang ingin Anda periksa dari berbagai varietas tanaman padi yang tersedia',
      image: 'icons/ic_rice_plant.png',
      bgColor: const Color(0xFF4CAF50),
      overlayColor: const Color(0xFF2E7D32),
      lightColor: const Color(0xFFA5D6A7),
    ),
    IntroData(
      title: 'Scan Tanaman Padi',
      description:
          'Arahkan kamera ke bagian tanaman yang ingin diperiksa untuk analisis dan deteksi penyakit',
      image: 'icons/ic_camera.png',
      bgColor: const Color(0xFF2196F3),
      overlayColor: const Color(0xFF1565C0),
      lightColor: const Color(0xFF90CAF9),
    ),
    IntroData(
      title: 'Hasil Diagnosis',
      description:
          'Lihat hasil diagnosis penyakit beserta rekomendasi cara penanganan dan pencegahannya',
      image: 'icons/ic_result.png',
      bgColor: const Color(0xFFFF9800),
      overlayColor: const Color(0xFFEF6C00),
      lightColor: const Color(0xFFFFCC80),
    ),
  ];

  // PageController tunggal hanya untuk pergantian halaman
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    // Inisialisasi page controller
    _pageController = PageController();
    _pageController.addListener(_handlePageChange);

    // Inisialisasi animasi controller
    _backgroundAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _contentAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  void _handlePageChange() {
    // Jika halaman saat ini berbeda dari _currentPage
    final page = (_pageController.page ?? 0).round();
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
        // Reset dan mulai animasi konten
        _contentAnimController.reset();
        _contentAnimController.forward();
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    _backgroundAnimController.dispose();
    _contentAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background animasi
          _buildAnimatedBackground(),

          // Konten utama dengan PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _introPages.length,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
                // Reset animasi konten saat halaman berubah
                _contentAnimController.reset();
                _contentAnimController.forward();
              });
            },
            itemBuilder: (context, index) {
              return _buildFullPageContent(_introPages[index], screenSize);
            },
          ),
        ],
      ),
    );
  }

  // Background dengan animasi
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimController,
      builder: (context, child) {
        return Stack(
          children: [
            // Base background color
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              color: _introPages[_currentPage].bgColor,
            ),

            // Animated shapes - circles
            Positioned(
              right: -100,
              top: -50,
              child: Transform.rotate(
                angle: _backgroundAnimController.value * 2 * math.pi,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _introPages[_currentPage].lightColor.withOpacity(0.3),
                  ),
                ),
              ),
            ),

            // Animated shapes - blob
            Positioned(
              left: -150 +
                  (math.sin(_backgroundAnimController.value * math.pi) * 50),
              bottom: 100 +
                  (math.cos(_backgroundAnimController.value * math.pi) * 50),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _introPages[_currentPage].overlayColor.withOpacity(0.2),
                ),
              ),
            ),

            // Small decorative elements
            for (int i = 0; i < 5; i++)
              Positioned(
                top: (i * 100) +
                    (math.sin(
                            _backgroundAnimController.value * 2 * math.pi + i) *
                        20),
                right: (i % 2 == 0) ? 40 + (i * 30) : null,
                left: (i % 2 != 0) ? 40 + (i * 20) : null,
                child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    width: 15 + (i * 3),
                    height: 15 + (i * 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Widget untuk konten halaman penuh
  Widget _buildFullPageContent(IntroData data, Size screenSize) {
    return Column(
      children: [
        // Bagian Header - Occupies 40% of screen
        SizedBox(
          height: screenSize.height * 0.45,
          child: _buildHeaderContent(data),
        ),

        // Bagian konten bawah
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Indikator halaman
                _buildPageIndicator(),

                const SizedBox(height: 30),

                // Konten deskripsi
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _buildDescriptionContent(data),
                  ),
                ),

                // Tombol navigasi
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk bagian header
  Widget _buildHeaderContent(IntroData data) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau branding
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Harvest Guard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Ilustrasi tengah
            AnimatedBuilder(
              animation: _contentAnimController,
              builder: (context, child) {
                // Scale up animation
                return Transform.scale(
                  scale: _contentAnimController.value,
                  child: Opacity(
                    opacity: _contentAnimController.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 180,
                height: 180,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForImage(data.image),
                      size: 60,
                      color: data.bgColor,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  // Widget untuk konten deskripsi
  Widget _buildDescriptionContent(IntroData data) {
    return AnimatedBuilder(
      animation: _contentAnimController,
      builder: (context, child) {
        // Slide up and fade in animation
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _contentAnimController.value)),
          child: Opacity(
            opacity: _contentAnimController.value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              data.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: data.bgColor,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 20),

            // Description
            Text(
              data.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 20),

            // Feature points - menambahkan beberapa fitur spesifik
            ...(_getFeaturesForPage(data))
                .map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: data.bgColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              feature.icon,
                              size: 16,
                              color: data.bgColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              feature.text,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),

            // Padding di bawah untuk memastikan scroll aman
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget untuk indikator halaman
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_introPages.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: _currentPage == index ? 30 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? _introPages[_currentPage].bgColor
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // Widget untuk tombol navigasi
  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
      child: Row(
        children: [
          const Spacer(),

          // Next/Finish button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _currentPage < _introPages.length - 1 ? 60 : 160,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _introPages.length - 1) {
                  _pageController.animateToPage(
                    _currentPage + 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Get.offNamed(AppRoutes.dashboard);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _introPages[_currentPage].bgColor,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _currentPage < _introPages.length - 1
                  ? const Icon(Icons.arrow_forward_rounded, size: 24)
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mulai Sekarang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk mendapatkan ikon berdasarkan nama file
  IconData _getIconForImage(String imagePath) {
    if (imagePath.contains('rice_plant')) {
      return Icons.grass_rounded;
    } else if (imagePath.contains('camera')) {
      return Icons.camera_alt_rounded;
    } else if (imagePath.contains('result')) {
      return Icons.fact_check_rounded;
    }
    return Icons.eco_rounded;
  }

  // Helper untuk mendapatkan fitur spesifik berdasarkan halaman
  List<FeatureItem> _getFeaturesForPage(IntroData data) {
    if (data.title.contains('Pilih Varietas')) {
      return [
        FeatureItem(Icons.category_rounded, 'Berbagai varietas padi tersedia'),
        FeatureItem(Icons.info_rounded, 'Informasi detail setiap varietas'),
        FeatureItem(Icons.bookmark_rounded, 'Simpan favorit untuk akses cepat'),
      ];
    } else if (data.title.contains('Scan')) {
      return [
        FeatureItem(Icons.autorenew_rounded, 'Deteksi cepat & akurat'),
        FeatureItem(Icons.photo_library_rounded, 'Gunakan foto dari galeri'),
        FeatureItem(Icons.crop_rounded, 'Crop gambar untuk hasil terbaik'),
      ];
    } else {
      return [
        FeatureItem(Icons.timeline_rounded, 'Analisis detail penyakit'),
        FeatureItem(Icons.healing_rounded, 'Rekomendasi penanganan'),
        FeatureItem(Icons.history_rounded, 'Riwayat pemeriksaan'),
      ];
    }
  }
}

// Model untuk data intro page
class IntroData {
  final String title;
  final String description;
  final String image;
  final Color bgColor;
  final Color overlayColor;
  final Color lightColor;

  IntroData({
    required this.title,
    required this.description,
    required this.image,
    required this.bgColor,
    required this.overlayColor,
    required this.lightColor,
  });
}

// Model untuk item fitur
class FeatureItem {
  final IconData icon;
  final String text;

  FeatureItem(this.icon, this.text);
}
