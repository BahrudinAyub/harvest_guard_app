import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/components/scan_history_card.dart';
import 'package:harvest_guard_app/dashboard/dashboard_controller.dart';

// Fungsi helper yang digunakan di seluruh widget
double getSafeAnimationValue(
    AnimationController controller, double start, double end) {
  // Pastikan nilai controller dibatasi antara 0.0 dan 1.0
  double safeValue = controller.value.clamp(0.0, 1.0);

  // Jika nilai lebih kecil dari start, kembalikan 0.0
  if (safeValue < start) return 0.0;

  // Jika nilai lebih besar dari end, kembalikan 1.0
  if (safeValue > end) return 1.0;

  // Normalisasi nilai ke rentang 0.0 - 1.0 berdasarkan start dan end
  return (safeValue - start) / (end - start);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardController controller;

  @override
  void initState() {
    super.initState();

    // Pastikan controller sudah diinisialisasi
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
    }
    controller = Get.find<DashboardController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan greeting dan avatar
                  _buildHeader(),

                  const SizedBox(height: 30),

                  // Welcome Banner with Animation
                  _buildWelcomeBanner(),

                  const SizedBox(height: 30),

                  // Main Action Card
                  _buildMainActionCard(),

                  const SizedBox(height: 25),

                  // Riwayat kesehatan section
                  _buildHistoryHeader(),

                  const SizedBox(height: 16),

                  // Riwayat scan list
                  _buildHistoryList(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Animated Background yang aman
  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Base gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                Colors.green.shade50,
                Colors.green.shade100,
              ],
            ),
          ),
        ),

        // Reactive color based on scan history
        Obx(() {
          final historyCount =
              controller.modelController.scanHistoryList.length;
          final baseColor = historyCount > 0
              ? Color.fromARGB(
                  255, 0, 120 + (historyCount * 10).clamp(0, 100), 0)
              : Colors.green.shade400;

          return Stack(
            children: [
              // Top blob with animation
              Positioned(
                top: -100,
                right: -50,
                child: AnimatedBuilder(
                  animation: controller.animationController,
                  builder: (context, child) {
                    // Menggunakan nilai yang aman untuk animasi
                    final sinValue = math.sin(
                        controller.animationController.value.clamp(0.0, 1.0) *
                            math.pi *
                            2);

                    return Transform.rotate(
                      angle: sinValue * 0.05,
                      child: Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              baseColor.withOpacity(0.3),
                              baseColor.withOpacity(0.1),
                              baseColor.withOpacity(0.0),
                            ],
                            stops: const [0.2, 0.6, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Decorative floating elements (shortened for brevity)
              for (int i = 0; i < 3; i++)
                Positioned(
                  top: 100 + (i * 150),
                  left: (i % 2 == 0) ? 20 : null,
                  right: (i % 2 == 0) ? null : 20,
                  child: AnimatedBuilder(
                    animation: controller.animationController,
                    builder: (context, child) {
                      final safeValue =
                          controller.animationController.value.clamp(0.0, 1.0);
                      final phase = i * 0.2;
                      final animValue = (safeValue + phase) % 1.0;

                      return Opacity(
                        opacity: 0.2,
                        child: Transform.translate(
                          offset: Offset(math.sin(animValue * math.pi * 2) * 10,
                              math.cos(animValue * math.pi * 2) * 10),
                          child: Icon(
                            Icons.eco,
                            size: 20.0,
                            color: baseColor.withOpacity(0.3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  // Header dengan animasi yang aman
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Greeting text dengan nama user
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                // Gunakan getSafeAnimationValue untuk nilai yang aman
                final progress = getSafeAnimationValue(
                    controller.animationController, 0.0, 0.3);
                final value = Curves.easeOut.transform(progress);

                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(-20 * (1 - value), 0),
                    child: Obx(() => Text(
                          'Hallo, ${controller.userName.value}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  Colors.green.shade700,
                                  Colors.green.shade500,
                                ],
                              ).createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        )),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                // Gunakan getSafeAnimationValue untuk nilai yang aman
                final progress = getSafeAnimationValue(
                    controller.animationController, 0.05, 0.35);
                final value = Curves.easeOut.transform(progress);

                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(-20 * (1 - value), 0),
                    child: const Text(
                      'Semoga panen melimpah!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        // Animated Avatar
        AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) {
            // Gunakan getSafeAnimationValue untuk nilai yang aman
            final progress =
                getSafeAnimationValue(controller.animationController, 0.0, 0.4);

            // Elastic animation dihitung dengan aman
            double elasticValue = 0.0;
            if (progress > 0.0) {
              try {
                elasticValue = Curves.elasticOut.transform(progress);
              } catch (_) {
                // Fallback jika masih ada error
                elasticValue = progress;
              }
            }

            return Transform.scale(
              scale: elasticValue.clamp(0.0, 1.0),
              child: GestureDetector(
                onTap: controller.switchUserProfile,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFD966),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.brown.shade800,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Welcome Banner dengan animasi yang aman
  Widget _buildWelcomeBanner() {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        // Gunakan getSafeAnimationValue untuk nilai yang aman
        final progress =
            getSafeAnimationValue(controller.animationController, 0.1, 0.5);
        final value = Curves.easeOut.transform(progress);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade300,
                    Colors.green.shade500,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Periksa kesehatan\npadimu sekarang!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Deteksi Dini Penyakit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Main Action Card dengan animasi yang aman
  Widget _buildMainActionCard() {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        // Gunakan getSafeAnimationValue untuk nilai yang aman
        final progress =
            getSafeAnimationValue(controller.animationController, 0.2, 0.6);
        final value = Curves.easeOut.transform(progress);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - value)),
            child: GestureDetector(
              onTap: controller.startScanning,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.green.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.green.shade200,
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Background decoration
                    Positioned(
                      bottom: -20,
                      right: -20,
                      child: Icon(
                        Icons.eco,
                        size: 100,
                        color: Colors.green.withOpacity(0.1),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 50,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          // Text content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Scan Tanaman',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Arahkan kamera ke tanaman padi untuk deteksi penyakit',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade500,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Mulai Scan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
            ),
          ),
        );
      },
    );
  }

  // History header dengan animasi yang aman
  Widget _buildHistoryHeader() {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        // Gunakan getSafeAnimationValue untuk nilai yang aman
        final progress =
            getSafeAnimationValue(controller.animationController, 0.3, 0.7);
        final value = Curves.easeOut.transform(progress);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 18,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Riwayat Pemeriksaan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // Selengkapnya button
                InkWell(
                  onTap: controller.navigateToScanHistoryDetail,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Selengkapnya',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.green.shade700,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // History list dengan animasi yang aman
  Widget _buildHistoryList() {
    return Expanded(
      child: AnimatedBuilder(
        animation: controller.animationController,
        builder: (context, _) {
          return Obx(() {
            final scanHistory = controller.modelController.scanHistoryList;

            if (scanHistory.isEmpty) {
              // Empty state dengan animasi aman
              final progress = getSafeAnimationValue(
                  controller.animationController, 0.4, 0.8);
              final value = Curves.easeOut.transform(progress);

              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Belum ada riwayat pemeriksaan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Mulai scan tanaman padi untuk melihat hasilnya disini',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            // Tampilkan 3 history terbaru saja
            final recentHistory = scanHistory.length > 3
                ? scanHistory.sublist(0, 3)
                : scanHistory;

            // Gunakan ListView dengan staggered effect aman
            return ListView.builder(
              itemCount: recentHistory.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = recentHistory[index];

                // Gunakan persen offset berbeda untuk setiap item secara bertahap
                final startValue = 0.45 + (index * 0.1); // 0.45, 0.55, 0.65
                final endValue = startValue + 0.2; // 0.65, 0.75, 0.85

                // Hitung animasi dengan nilai aman
                final progress = getSafeAnimationValue(
                    controller.animationController, startValue, endValue);

                final opacity = Curves.easeOut.transform(progress);

                if (opacity <= 0.01) {
                  return const SizedBox
                      .shrink(); // Sembunyikan sampai animasi dimulai
                }

                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - opacity)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: _buildEnhancedHistoryCard(item),
                    ),
                  ),
                );
              },
            );
          });
        },
      ),
    );
  }

  // Enhanced history card
  Widget _buildEnhancedHistoryCard(dynamic item) {
    // Ini adalah versi yang lebih bagus dari ScanHistoryCard
    // Anda perlu menyesuaikan dengan properties yang ada di model Anda

    Color statusColor;
    IconData statusIcon;

    // Tentukan warna dan icon berdasarkan hasil diagnosis
    if (item.confidence > 80) {
      statusColor = Colors.red.shade400;
      statusIcon = Icons.warning_rounded;
    } else if (item.confidence > 50) {
      statusColor = Colors.orange.shade400;
      statusIcon = Icons.warning_amber_rounded;
    } else {
      statusColor = Colors.green.shade400;
      statusIcon = Icons.check_circle_rounded;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigasi ke detail item
            controller.openHistoryDetail(item);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Status indicator
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      statusIcon,
                      color: statusColor,
                      size: 26,
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.diseaseResult,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.timestamp.toString().substring(0, 10),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.bar_chart_rounded,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.confidence.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Floating Action Button dengan animasi yang aman
  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        // Gunakan getSafeAnimationValue untuk nilai yang aman
        final progress =
            getSafeAnimationValue(controller.animationController, 0.6, 1.0);

        // Elastic animation dihitung dengan aman
        double elasticValue = 0.0;
        if (progress > 0) {
          try {
            elasticValue = Curves.elasticOut.transform(progress);
          } catch (_) {
            // Fallback jika masih ada error
            elasticValue = progress;
          }
        }

        // Batasi nilai antara 0.0 dan 1.0
        elasticValue = elasticValue.clamp(0.0, 1.0);

        return Transform.scale(
          scale: elasticValue,
          child: FloatingActionButton.extended(
            onPressed: controller.startScanning,
            backgroundColor: Colors.green.shade600,
            icon: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
            ),
            label: const Text(
              'Scan Baru',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 5,
          ),
        );
      },
    );
  }
}
