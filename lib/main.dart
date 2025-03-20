import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_guard_app/data/scan_history_model.dart';
import 'package:harvest_guard_app/routes/app_routes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  runApp(const MainApp());
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(ScanHistoryAdapter());
  

}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harvest Guard',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}
