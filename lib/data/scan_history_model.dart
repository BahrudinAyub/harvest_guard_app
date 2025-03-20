import 'package:hive/hive.dart';
import 'dart:io';

part 'scan_history_model.g.dart'; // Ini wajib ada

@HiveType(typeId: 1)
class ScanHistory extends HiveObject {
  @HiveField(0)
  final String imagePath;

  @HiveField(1)
  final String diseaseResult;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final double confidence;

  @HiveField(4)
  final String diseaseId;

  ScanHistory({
    required this.imagePath,
    required this.diseaseResult,
    required this.timestamp,
    required this.confidence,
    required this.diseaseId,
  });
}
