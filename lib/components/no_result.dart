import 'package:flutter/material.dart';
import 'package:harvest_guard_app/components/abstract_class.dart';

class TidakTeridentifikasiPage extends BaseDiseaseDetailPage {
  TidakTeridentifikasiPage() : super(
    title: 'Tidak Teridentifikasi',
    description: 'Model tidak dapat mengidentifikasi jenis penyakit pada gambar. Hal ini dapat terjadi karena beberapa alasan, seperti gambar kurang jelas, gejala belum terlihat jelas, atau mungkin penyakit tersebut tidak termasuk dalam kategori yang dikenali oleh model.',
    treatments: [
      'Konsultasikan dengan ahli pertanian atau penyuluh pertanian setempat',
      'Ambil gambar ulang dengan kualitas yang lebih baik dan pencahayaan yang cukup',
      'Lakukan pengamatan lebih dekat terhadap gejala yang muncul',
      'Jika memungkinkan, bawa sampel tanaman ke laboratorium untuk analisis lebih lanjut'
    ],
    preventions: [
      'Lakukan pemantauan rutin pada tanaman',
      'Terapkan praktik pertanian yang baik dan seimbang',
      'Jaga kebersihan lingkungan pertanaman',
      'Lakukan rotasi tanaman untuk memutus siklus patogen'
    ],
  );
}