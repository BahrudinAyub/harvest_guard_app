import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:harvest_guard_app/data/scan_history_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ModelController extends GetxController {
  Interpreter? _interpreter;

  // Status model
  RxBool isModelLoaded = false.obs;
  RxString modelError = "".obs;
  
  // Scan history box reference
  late Box<ScanHistory> scanHistoryBox;
  RxList<ScanHistory> scanHistoryList = <ScanHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    initHive();
    loadModel();
  }
  
  // Initialize Hive and open box
  Future<void> initHive() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      Hive.init(appDir.path);
      
      // Register the ScanHistory adapter if not already registered
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(ScanHistoryAdapter());
      }
      
      // Open the scan history box
      scanHistoryBox = await Hive.openBox<ScanHistory>('scan_history');
      
      // Load scan history into observable list
      loadScanHistory();
      
      print('Hive initialized successfully');
    } catch (e) {
      print('Failed to initialize Hive: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to initialize local storage: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Load scan history from Hive box
  void loadScanHistory() {
    scanHistoryList.value = scanHistoryBox.values.toList();
    // Sort by timestamp (newest first)
    scanHistoryList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
  
  // Save scan result to Hive
  Future<void> saveScanResult(File imageFile, Map<String, dynamic> prediction) async {
    try {
      // Create a copy of the image in app's document directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImagePath = '${appDir.path}/$fileName';
      
      // Copy image file
      final savedImageFile = await imageFile.copy(savedImagePath);
      
      // Create scan history entry
      final scanHistory = ScanHistory(
        imagePath: savedImageFile.path,
        diseaseResult: prediction['disease'],
        timestamp: DateTime.now(),
        confidence: prediction['confidence'],
        diseaseId: prediction['diseaseId'],
      );
      
      // Save to Hive box
      await scanHistoryBox.add(scanHistory);
      
      // Refresh the list
      loadScanHistory();
      
      print('Scan result saved successfully');
    } catch (e) {
      print('Failed to save scan result: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to save scan result: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Delete scan history item
  Future<void> deleteScanHistory(ScanHistory history) async {
    try {
      // Delete the image file
      final imageFile = File(history.imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      
      // Delete from Hive
      await history.delete();
      
      // Refresh the list
      loadScanHistory();
      
      print('Scan history deleted successfully');
    } catch (e) {
      print('Failed to delete scan history: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to delete scan history: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk memuat model TensorFlow Lite
  Future<void> loadModel() async {
    print('Memulai pemuatan model...');
    try {
      // Cek apakah file model ada
      final modelPath = 'assets/model/rice_disease_model.tflite';
      final assetFile = await rootBundle.load(modelPath);
      print('Model file ditemukan! Ukuran: ${assetFile.lengthInBytes} bytes');

      // Opsi yang lebih permisif untuk model yang lebih baru
      final interpreterOptions = InterpreterOptions()
        ..useNnApiForAndroid =
            false // Matikan NNAPI untuk kecocokan yang lebih baik
        ..threads = 2; // Batasi thread untuk stabilitas

      _interpreter = await Interpreter.fromAsset(
        modelPath,
        options: interpreterOptions,
      );

      // Cetak informasi tentang model
      print('Model berhasil dimuat!');
      print(
          'Input Tensor Shapes: ${_interpreter!.getInputTensors().map((t) => t.shape).toList()}');
      print(
          'Output Tensor Shapes: ${_interpreter!.getOutputTensors().map((t) => t.shape).toList()}');

      isModelLoaded.value = true;
    } catch (e) {
      modelError.value = e.toString();
      print('Gagal memuat model: ${e.toString()}');

      // Coba cara alternatif loading model
      try {
        print('Mencoba cara alternatif loading model...');
        final modelPath = 'assets/model/rice_disease_model.tflite';

        // Coba dengan opsi yang lebih permisif
        final interpreterOptions = InterpreterOptions()
          ..useNnApiForAndroid = false
          ..threads = 1;

        // Baca file model sebagai ByteData dan konversi ke Uint8List
        final byteData = await rootBundle.load(modelPath);
        print(
            'Model file loaded as ByteData, size: ${byteData.lengthInBytes} bytes');

        // Konversi ByteData ke Uint8List yang dibutuhkan oleh Interpreter.fromBuffer
        final buffer = byteData.buffer;
        final uint8List = Uint8List.view(
            buffer, byteData.offsetInBytes, byteData.lengthInBytes);

        _interpreter = await Interpreter.fromBuffer(
          uint8List,
          options: interpreterOptions,
        );

        print('Model berhasil dimuat dengan cara alternatif!');
        isModelLoaded.value = true;
      } catch (e2) {
        print('Tetap gagal memuat model: ${e2.toString()}');
        modelError.value += "\n\nPercobaan kedua: ${e2.toString()}";

        Get.snackbar(
          'Error',
          'Gagal memuat model: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      }
    }
  }

  Future<Map<String, Object>> analyzeImage(File imageFile) async {
    if (_interpreter == null || !isModelLoaded.value) {
      print('Model tidak dimuat, coba dimuat ulang...');
      await loadModel();

      if (_interpreter == null) {
        print('Gagal memuat model, tidak bisa melanjutkan analisis');
        return {
          'status': 'error',
          'message':
              'Model tidak dapat dimuat. Detail error:\n${modelError.value}'
        };
      }
    }

    print('Memulai analisis gambar...');

    try {
      final processedImage = await loadAndPreprocessImage(imageFile);
      print('Ukuran tensor input: ${processedImage.runtimeType}');

      // Siapkan tensor output berdasarkan bentuk model
      var outputShape = _interpreter!.getOutputTensors().first.shape;
      print('Bentuk tensor output: $outputShape');

      var output = List<double>.filled(outputShape.reduce((a, b) => a * b), 0.0)
          .reshape(outputShape);
      print('Tensor output dibuat, ukuran: ${output.length}');

      // Jalankan model
      print('Menjalankan inferensi...');
      _interpreter?.run(processedImage, output);

      print('Analisis selesai, hasil prediksi: ${output[0]}');

      // Ambil kelas dengan nilai tertinggi sebagai hasil prediksi
      // Eksplisit mengkonversi output ke List<double> untuk memastikan tipe data yang benar
      List<double> outputList = List<double>.from(output[0]);

      // Temukan indeks dengan nilai tertinggi
      int predictedClass = findMaxIndex(outputList);
      print(
          'Predicted class index: $predictedClass with confidence: ${outputList[predictedClass]}');

      // Dapatkan hasil prediksi
      final predictionResult =
          getDiseasePrediction(predictedClass, outputList[predictedClass]);
      
      // Save scan result to Hive
      await saveScanResult(imageFile, predictionResult);

      return {'status': 'success', 'result': predictionResult};
    } catch (e) {
      print('Gagal menganalisis gambar: ${e.toString()}');
      return {'status': 'error', 'message': 'Gagal menganalisis gambar: $e'};
    }
  }

  // Fungsi pembantu untuk menemukan indeks dengan nilai tertinggi
  int findMaxIndex(List<double> list) {
    double maxValue = list[0];
    int maxIndex = 0;

    for (int i = 1; i < list.length; i++) {
      if (list[i] > maxValue) {
        maxValue = list[i];
        maxIndex = i;
      }
    }

    return maxIndex;
  }

  // Mendapatkan prediksi penyakit berdasarkan indeks kelas
  Map<String, dynamic> getDiseasePrediction(
      int predictedClass, double confidence) {
    String diseaseResult = '';
    String routeName = '';
    String diseaseId = '';

    // Gunakan class mapping yang benar berdasarkan data yang Anda berikan
    switch (predictedClass) {
      case 0:
        diseaseResult = 'Hawar Daun Bakteri';
        routeName = '/hawar-daun';
        diseaseId = 'hawar_daun';
        break;
      case 1:
        diseaseResult = 'Bercak Coklat';
        routeName = '/bercak-coklat';
        diseaseId = 'bercak_coklat';
        break;
      case 2:
        diseaseResult = 'Sehat';
        routeName = '/sehat';
        diseaseId = 'sehat';
        break;
      case 3:
        diseaseResult = 'Hispa';
        routeName = '/hispa';
        diseaseId = 'hispa';
        break;
      default:
        diseaseResult = 'Tidak Teridentifikasi';
        routeName = '/tidak-teridentifikasi';
        diseaseId = 'tidak_teridentifikasi';
        break;
    }

    return {
      'disease': diseaseResult,
      'confidence': confidence,
      'routeName': routeName,
      'diseaseId': diseaseId
    };
  }

  Future<dynamic> loadAndPreprocessImage(File image) async {
    print('Memuat dan memproses gambar...');
    final imageInput = await loadImage(image);
    final imagePreprocessed = preprocessImage(imageInput);
    print('Gambar berhasil diproses');
    return imagePreprocessed;
  }

  Future<img.Image> loadImage(File imageFile) async {
    print('Membaca gambar dari file...');
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(Uint8List.fromList(bytes));

    if (image == null) {
      print('Gagal membaca gambar');
      throw Exception('Gagal membaca gambar');
    }

    print('Gambar berhasil dibaca');
    return image;
  }

  // Modified preprocessing function to add batch dimension
  List<List<List<List<double>>>> preprocessImage(img.Image imageInput) {
    print('Memulai preprocessing gambar...');
    // Resize gambar ke ukuran 224x224 (sesuai kebutuhan model)
    img.Image resizedImage =
        img.copyResize(imageInput, width: 224, height: 224);

    // Buat tensor 4D [batch, height, width, channel] dengan batch = 1
    List<List<List<List<double>>>> normalized = [
      List.generate(
        resizedImage.height,
        (y) => List.generate(
          resizedImage.width,
          (x) {
            // Ambil pixel di posisi (x,y)
            final pixel = resizedImage.getPixel(x, y);

            // Ekstrak nilai RGB menggunakan properti langsung dari objek pixel
            final double rNorm = pixel.r / 255.0;
            final double gNorm = pixel.g / 255.0;
            final double bNorm = pixel.b / 255.0;

            // Return [r, g, b] untuk setiap pixel
            return [rNorm, gNorm, bNorm];
          },
        ),
      )
    ];

    print(
        'Preprocessing selesai, dimensi output: 1x${normalized[0].length}x${normalized[0][0].length}x${normalized[0][0][0].length}');
    return normalized;
  }

  @override
  void onClose() {
    if (_interpreter != null) {
      try {
        _interpreter!.close();
        print('Interpreter berhasil ditutup');
      } catch (e) {
        print('Error saat menutup interpreter: $e');
      }
    }
    // Close Hive box
    scanHistoryBox.close();
    super.onClose();
  }
}