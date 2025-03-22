import 'package:get/get.dart';
import 'package:harvest_guard_app/components/bacterial_leaf_blight.dart';
import 'package:harvest_guard_app/components/brown_spot_result.dart';
import 'package:harvest_guard_app/components/healty_result.dart';
import 'package:harvest_guard_app/components/hispa_result.dart';
import 'package:harvest_guard_app/components/no_result.dart';
import 'package:harvest_guard_app/components/scan_history_screen.dart';
import 'package:harvest_guard_app/components/splashscreen.dart';
import 'package:harvest_guard_app/dashboard/dashboard_binding.dart';
import 'package:harvest_guard_app/dashboard/dashboard_page.dart';
import 'package:harvest_guard_app/intro/page_intro.dart';
import 'package:harvest_guard_app/periksa/periksa_binding.dart';
import 'package:harvest_guard_app/periksa/periksa_controller.dart';
import 'package:harvest_guard_app/periksa/periksa_page.dart';

class AppRoutes {
  // Route names sebagai konstanta
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String periksa = '/periksa';
  static const String scanHistory = '/scan-history';
  static const String intro = '/intro';

  // Daftar route aplikasi
  static final List<GetPage> pages = [
    GetPage(
      name: intro,
      page: () => const IntroScreen(),
    ),
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: periksa,
      page: () => const PeriksaScreen(),
      binding: PeriksaBinding(),
    ),
    GetPage(
      name: '/hawar-daun',
      page: () => HawarDaunPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/bercak-coklat',
      page: () => BercakCoklatPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/sehat',
      page: () => SehatPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/hispa',
      page: () => HispaPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/tidak-teridentifikasi',
      page: () => TidakTeridentifikasiPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.periksa,
      page: () => const PeriksaScreen(),
      binding: BindingsBuilder(() {
        Get.put(PeriksaController());
      }),
    ),
    GetPage(
      name: AppRoutes.scanHistory,
      page: () => const ScanHistoryScreen(),
    ),
  ];
}
