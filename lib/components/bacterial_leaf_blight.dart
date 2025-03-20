import 'package:flutter/material.dart';
import 'package:harvest_guard_app/components/abstract_class.dart';


class HawarDaunPage extends BaseDiseaseDetailPage {
  HawarDaunPage() : super(
    title: 'Hawar Daun Bakteri',
    description: 'Hawar daun bakteri (BLB) adalah penyakit yang disebabkan oleh bakteri Xanthomonas oryzae. Penyakit ini ditandai dengan bercak-bercak berwarna kuning hingga putih yang mengikuti pembuluh daun, dan selanjutnya dapat menyebabkan daun menjadi kering dan mati. Penyakit ini dapat menyebar dengan cepat terutama pada kondisi basah dan lembab.',
    treatments: [
      'Aplikasikan bakterisida yang direkomendasikan sesuai dosis yang tepat',
      'Keringkan sawah secara berkala untuk mengurangi kelembaban',
      'Pangkas dan buang bagian tanaman yang terinfeksi parah',
      'Jaga jarak tanam yang cukup untuk mengurangi kelembaban mikro',
      'Gunakan pupuk nitrogen dengan dosis yang seimbang'
    ],
    preventions: [
      'Tanam varietas padi yang tahan terhadap hawar daun bakteri',
      'Gunakan benih bebas patogen dan berkualitas',
      'Hindari penggunaan pupuk nitrogen berlebihan',
      'Lakukan rotasi tanaman',
      'Bersihkan area sekitar tanaman dari gulma yang dapat menjadi inang alternatif'
    ],
  );
}