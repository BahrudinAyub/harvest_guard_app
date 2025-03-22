import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Base class untuk semua halaman penyakit dengan UI yang lebih estetik
abstract class BaseDiseaseDetailPage extends StatefulWidget {
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
  State<BaseDiseaseDetailPage> createState() => _BaseDiseaseDetailPageState();
}

class _BaseDiseaseDetailPageState extends State<BaseDiseaseDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();

    // Setup animasi
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Setup scroll controller untuk efek app bar
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Mulai animasi
    _animationController.forward();
  }

  void _onScroll() {
    // Menunjukkan judul di app bar ketika scroll melewati batas tertentu
    if (_scrollController.offset > 200 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset <= 200 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan argumen dari navigasi
    final args = Get.arguments as Map<String, dynamic>;
    final prediction = args['prediction'] as Map<String, dynamic>;
    final imagePath = args['imagePath'] as String?;
    final confidence = (prediction['confidence'] as double) * 100;

    return Scaffold(
      body: Stack(
        children: [
          // Content dengan scroll
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App bar dengan image header
              _buildSliverAppBar(imagePath, confidence, prediction),

              // Content main
              SliverToBoxAdapter(
                child: _buildMainContent(prediction, confidence),
              ),
            ],
          ),

          // Gradient overlay di bagian atas untuk app bar efek
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top +
                56, // Safe area + app bar height
            child: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.white.withOpacity(0.8),
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    child: Center(
                      child: Text(
                        _showTitle ? prediction['disease'] as String : '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: _buildBackButton(),
          ),

          // Share button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: _buildShareButton(),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final scale = Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
              ))
              .value;

          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: FloatingActionButton.extended(
          onPressed: () {
            // Kembali ke halaman scan
            Get.until((route) => route.settings.name == '/');
          },
          icon: const Icon(Icons.camera_alt_rounded),
          label: const Text('Scan Baru'),
          backgroundColor: Colors.green.shade600,
          elevation: 4,
        ),
      ),
    );
  }

  // Custom SliverAppBar dengan gambar
  Widget _buildSliverAppBar(
      String? imagePath, double confidence, Map<String, dynamic> prediction) {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image background
            if (imagePath != null)
              Hero(
                tag: 'disease_image',
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.green.shade300,
                      Colors.green.shade600,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.grass_rounded,
                    size: 80,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),

            // Gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black26,
                    Colors.black45,
                  ],
                ),
              ),
            ),

            // Status dan indikator
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _getConfidenceColor(confidence).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getConfidenceIcon(confidence),
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${confidence.toStringAsFixed(1)}% Keyakinan',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Classification label
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.health_and_safety_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Diagnosis',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian konten utama
  Widget _buildMainContent(Map<String, dynamic> prediction, double confidence) {
    return Container(
      padding: const EdgeInsets.only(bottom: 100),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan judul penyakit
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                ));

                final fadeAnimation = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                ));

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prediction['disease'] as String,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.agriculture_rounded,
                              size: 14,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Tanaman Padi',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              _getConfidenceColor(confidence).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getConfidenceColor(confidence)
                                .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getSeverityIcon(confidence),
                              size: 14,
                              color: _getConfidenceColor(confidence),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getSeverityText(confidence),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getConfidenceColor(confidence),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Divider custom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Container(
              height: 1,
              color: Colors.grey.shade200,
            ),
          ),

          // Description section
          _buildSection(
            title: 'Tentang Penyakit',
            icon: Icons.info_outline_rounded,
            content: widget.description,
            delay: 0.1,
          ),

          // Treatment section
          if (widget.treatments.isNotEmpty)
            _buildListSection(
              title: 'Cara Penanganan',
              icon: Icons.healing_rounded,
              items: widget.treatments,
              itemIcon: Icons.check_circle_rounded,
              itemColor: Colors.green.shade600,
              delay: 0.2,
            ),

          // Prevention section
          _buildListSection(
            title: 'Cara Pencegahan',
            icon: Icons.shield_rounded,
            items: widget.preventions,
            itemIcon: Icons.shield_moon_rounded,
            itemColor: Colors.blue.shade600,
            delay: 0.3,
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.4, 0.8, curve: Curves.easeOut),
                ));

                final fadeAnimation = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.4, 0.8, curve: Curves.easeOut),
                ));

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('Bagikan Hasil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.info_outline_rounded),
                      label: const Text('Info Lanjut'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green.shade700,
                        side: BorderSide(
                            color: Colors.green.shade400, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
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
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk section dengan text biasa
  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
    required double delay,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.1 + delay, 0.6 + delay, curve: Curves.easeOut),
          ));

          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.1 + delay, 0.6 + delay, curve: Curves.easeOut),
          ));

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk section dengan list items
  Widget _buildListSection({
    required String title,
    required IconData icon,
    required List<String> items,
    required IconData itemIcon,
    required Color itemColor,
    required double delay,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.1 + delay, 0.6 + delay, curve: Curves.easeOut),
          ));

          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.1 + delay, 0.6 + delay, curve: Curves.easeOut),
          ));

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: i < items.length - 1 ? 12 : 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            itemIcon,
                            color: itemColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              items[i],
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk tombol kembali
  Widget _buildBackButton() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale = Tween<double>(
          begin: 0.0,
          end: 1.0,
        )
            .animate(CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
            ))
            .value;

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.black87,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk tombol share
  Widget _buildShareButton() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale = Tween<double>(
          begin: 0.0,
          end: 1.0,
        )
            .animate(CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.1, 0.5, curve: Curves.elasticOut),
            ))
            .value;

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.snackbar(
                'Bagikan',
                'Fitur berbagi akan segera tersedia',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.share_rounded,
                color: Colors.black87,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper functions untuk warna dan ikon yang sesuai dengan tingkat keyakinan
  Color _getConfidenceColor(double confidence) {
    if (confidence > 80) {
      return Colors.red;
    } else if (confidence > 60) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  IconData _getConfidenceIcon(double confidence) {
    if (confidence > 80) {
      return Icons.priority_high_rounded;
    } else if (confidence > 60) {
      return Icons.warning_amber_rounded;
    } else {
      return Icons.check_circle_rounded;
    }
  }

  IconData _getSeverityIcon(double confidence) {
    if (confidence > 80) {
      return Icons.dangerous_rounded;
    } else if (confidence > 60) {
      return Icons.warning_amber_rounded;
    } else {
      return Icons.check_circle_outline_rounded;
    }
  }

  String _getSeverityText(double confidence) {
    if (confidence > 80) {
      return 'Parah';
    } else if (confidence > 60) {
      return 'Sedang';
    } else {
      return 'Ringan';
    }
  }
}
