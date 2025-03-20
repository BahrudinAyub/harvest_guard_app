import 'package:flutter/material.dart';
import 'package:harvest_guard_app/components/abstract_class.dart';


class SehatPage extends BaseDiseaseDetailPage {
  SehatPage() : super(
    title: 'Tanaman Sehat',
    description: 'Tanaman padi Anda tampak sehat dan tidak terdeteksi adanya penyakit. Tanaman padi yang sehat memiliki daun berwarna hijau cerah, batang yang kuat, dan tidak ada tanda-tanda bercak, klorosis (menguning), atau kerusakan lainnya. Tanaman yang sehat akan memberikan hasil panen yang optimal.',
    treatments: [],  // Tidak perlu penanganan khusus
    preventions: [
      'Lanjutkan praktik pertanian yang baik',
      'Pantau tanaman secara teratur untuk deteksi dini penyakit',
      'Jaga keseimbangan nutrisi tanaman melalui pemupukan yang tepat',
      'Kelola air dengan baik untuk mendukung pertumbuhan optimal',
      'Kendalikan gulma dan hama secara berkala'
    ],
  );
}