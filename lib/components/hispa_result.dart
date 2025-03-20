import 'package:flutter/material.dart';
import 'package:harvest_guard_app/components/abstract_class.dart';

class HispaPage extends BaseDiseaseDetailPage {
  HispaPage() : super(
    title: 'Hispa',
    description: 'Hispa adalah serangan hama yang disebabkan oleh kumbang Dicladispa armigera. Hama ini menyerang daun padi dan menyebabkan bercak-bercak putih, transparan hingga kering pada daun. Larva dari kumbang ini menggali di dalam jaringan daun, sementara kumbang dewasa mengikis permukaan daun. Serangan parah dapat mengurangi fotosintesis dan menurunkan hasil panen.',
    treatments: [
      'Aplikasikan insektisida yang direkomendasikan sesuai dengan tingkat serangan',
      'Kumpulkan dan musnahkan daun yang terserang parah',
      'Kurangi penggunaan pupuk nitrogen berlebihan yang dapat menarik hama',
      'Gunakan pengendalian hayati seperti predator alami jika memungkinkan',
      'Lakukan penyemprotan pada pagi atau sore hari untuk efektivitas maksimal'
    ],
    preventions: [
      'Tanam varietas padi yang tahan terhadap serangan hispa',
      'Kelola air dengan baik, termasuk pengeringan berkala',
      'Pantau tanaman secara rutin untuk deteksi dini',
      'Jaga kebersihan area sekitar sawah dari gulma',
      'Terapkan sistem tanam terpadu (IPM) untuk pengendalian hama'
    ],
  );
}