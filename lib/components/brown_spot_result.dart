import 'package:flutter/material.dart';
import 'package:harvest_guard_app/components/abstract_class.dart';


class BercakCoklatPage extends BaseDiseaseDetailPage {
  BercakCoklatPage() : super(
    title: 'Bercak Coklat',
    description: 'Bercak coklat (Brown Spot) adalah penyakit yang disebabkan oleh jamur Bipolaris oryzae. Penyakit ini ditandai dengan bercak-bercak berbentuk oval dengan warna coklat tua dan biasanya memiliki tepi berwarna kuning. Penyakit ini sering terjadi pada tanaman yang kekurangan nutrisi atau mengalami stres, dan dapat menyebabkan penurunan hasil panen yang signifikan.',
    treatments: [
      'Aplikasikan fungisida yang sesuai berdasarkan rekomendasi ahli',
      'Perbaiki drainase untuk mengurangi kelembaban berlebih',
      'Buang bagian tanaman yang terinfeksi',
      'Lakukan pemupukan seimbang untuk memperbaiki kondisi tanaman',
      'Kelola air dengan baik untuk mengurangi kelembaban lingkungan'
    ],
    preventions: [
      'Gunakan benih sehat dan berkualitas',
      'Lakukan perlakuan benih dengan fungisida sebelum tanam',
      'Jaga keseimbangan nutrisi dalam tanah, terutama kalium',
      'Tanam varietas yang tahan terhadap penyakit bercak coklat',
      'Hindari kepadatan tanaman yang terlalu tinggi'
    ],
  );
}