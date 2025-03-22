import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/routes/app_routes.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<IntroPage> _introPages = [
    IntroPage(
      title: 'Pilih Varietas Padi',
      description:
          'Pilih jenis padi yang ingin Anda periksa dari daftar varietas yang tersedia',
      icon: Icons.grass_rounded,
      color: Colors.green.shade400,
    ),
    IntroPage(
      title: 'Scan Tanaman Padi',
      description:
          'Arahkan kamera ponsel Anda ke bagian tanaman padi yang ingin diperiksa',
      icon: Icons.document_scanner_rounded,
      color: Colors.blue.shade400,
    ),
    IntroPage(
      title: 'Cek Hasil Diagnosis',
      description:
          'Dapatkan hasil diagnosis penyakit dan rekomendasi penanganannya',
      icon: Icons.checklist_rounded,
      color: Colors.orange.shade400,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background animasi bergerak
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: -100 + (_currentPage * 50),
            right: -100 + (_currentPage * 40),
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    _introPages[_currentPage].color.withOpacity(0.7),
                    _introPages[_currentPage].color.withOpacity(0.0),
                  ],
                  stops: const [0.1, 1.0],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            bottom: -80 + (_currentPage * 30),
            left: -50 + (_currentPage * 20),
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    _introPages[_currentPage].color.withOpacity(0.5),
                    _introPages[_currentPage].color.withOpacity(0.0),
                  ],
                  stops: const [0.1, 1.0],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _introPages.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildIntroPage(_introPages[index]);
                  },
                ),
              ),

              // Pagination indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _introPages.length,
                    (index) => _buildDotIndicator(index),
                  ),
                ),
              ),

              // Bottom buttons
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Next/Finish button
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _introPages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Get.offNamed(AppRoutes.dashboard);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _introPages[_currentPage].color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _currentPage < _introPages.length - 1
                            ? 'Lanjut'
                            : 'Mulai',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage(IntroPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with animated container
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: page.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    page.icon,
                    size: 80,
                    color: page.color,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Title
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Text(
                    page.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Description
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Text(
                    page.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? _introPages[_currentPage].color
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class IntroPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  IntroPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
