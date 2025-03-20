import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'model_controller.dart';

class PeriksaController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<CroppedFile?> croppedFile = Rx<CroppedFile?>(null);
  final ImagePicker _picker = ImagePicker();

  // Referensi ke controller model
  late final ModelController modelController;

  @override
  void onInit() {
    super.onInit();

    // Cek apakah ModelController sudah terdaftar
    if (!Get.isRegistered<ModelController>()) {
      // Jika belum, daftarkan ModelController
      Get.put(ModelController());
    }

    // Dapatkan reference ke ModelController
    modelController = Get.find<ModelController>();
  }

  Future<void> takePhoto() async {
    try {
      print('Mengambil foto...');
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        selectedImage.value = File(photo.path);
        print('Foto berhasil diambil!');
        await cropImage();
      }
    } catch (e) {
      print('Gagal mengambil foto: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Gagal mengambil foto: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickFromGallery() async {
    try {
      print('Memilih gambar dari galeri...');
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
        print('Gambar berhasil dipilih!');
        await cropImage();
      }
    } catch (e) {
      print('Gagal memilih gambar: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> cropImage() async {
    if (selectedImage.value != null) {
      try {
        print('Memotong gambar...');
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: selectedImage.value!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 90,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Potong Gambar',
              toolbarColor: Colors.green,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
            IOSUiSettings(
              title: 'Potong Gambar',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
            WebUiSettings(
              context: Get.context!,
              presentStyle: WebPresentStyle.dialog,
              size: const CropperSize(
                width: 520,
                height: 520,
              ),
            ),
          ],
        );

        if (croppedImage != null) {
          croppedFile.value = croppedImage;
          selectedImage.value = File(croppedImage.path);
          print('Gambar berhasil dipotong!');
          await processImageAnalysis();
        }
      } catch (e) {
        print('Gagal memotong gambar: ${e.toString()}');
        Get.snackbar(
          'Error',
          'Gagal memotong gambar: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> processImageAnalysis() async {
    if (selectedImage.value == null) {
      print('Gambar tidak dipilih');
      Get.snackbar(
        'Error',
        'Silahkan pilih gambar terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    print('Memulai analisis gambar...');
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // Gunakan controller model untuk analisis
    final result = await modelController.analyzeImage(selectedImage.value!);

    // Tutup dialog loading
    Get.back();

    if (result['status'] == 'error') {
      // Tampilkan dialog error
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(result['message'] as String),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Tampilkan hasil analisis
      final prediction = result['result'] as Map<String, dynamic>;
      showResultDialog(prediction);
    }
  }

  void showResultDialog(Map<String, dynamic> prediction) {
    // Tampilkan dialog singkat dengan hasil prediksi
    Get.dialog(
      AlertDialog(
        title: const Text('Hasil Analisis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prediksi: ${prediction['disease']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Text(
                'Tingkat keyakinan: ${(prediction['confidence'] * 100).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () {
              // Tutup dialog
              Get.back();

              // Arahkan ke halaman detail berdasarkan hasil prediksi
              navigateToDetailPage(prediction);
            },
            child: const Text('Lihat Detail'),
          ),
        ],
      ),
    );
  }

  void navigateToDetailPage(Map<String, dynamic> prediction) {
    // Ambil routeName dari hasil prediksi
    final String routeName = prediction['routeName'] as String;

    // Navigasi ke halaman yang sesuai dengan argumen
    Get.toNamed(routeName, arguments: {
      'prediction': prediction,
      'imagePath': selectedImage.value?.path
    });
  }
}
