import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/tip_item.dart';

class TipsService {
  Map<String, List<TipItem>> _tipsMap = <String, List<TipItem>>{
    'arithmetic': [
      const TipItem('01', 'Kerjakan operasi dalam tanda kurung lebih dulu, lalu ×÷, baru ±.'),
      const TipItem('02', 'Diskon: kalikan harga × persen, hasilnya dikurang harga awal.'),
      const TipItem('03', 'Persentase cepat: 10% = geser koma satu, 5% = setengahnya.'),
      const TipItem('04', 'Jarak = kecepatan × waktu. Hafalkan rumus ini.'),
    ],
    'sequence': [
      const TipItem('01', 'Cek selisih antar suku: jika sama → deret aritmetika.'),
      const TipItem('02', 'Jika selisih tidak sama, cek selisih dari selisih (bertingkat).'),
      const TipItem('03', 'Jika suku dibagi suku sebelumnya sama → deret geometri (rasio tetap).'),
      const TipItem('04', 'Deret Fibonacci: suku = jumlah dua suku sebelumnya. Cek dulu!'),
    ],
    'algebra': [
      const TipItem('01', 'Isolasi variabel: pindahkan konstanta ke kanan, koefisien bagi.'),
      const TipItem('02', 'Sistem persamaan: tambahkan/kurangkan kedua persamaan untuk eliminasi.'),
      const TipItem('03', r'Substitusi nilai $x$ ke persamaan lain untuk cek kebenaran jawaban.'),
      const TipItem('04', r'Ingat: $x^2$ berarti $x \times x$, bukan $x \times 2$.'),
    ],
    'logic': [
      const TipItem('01', r'KPK: $\text{KPK}(a,b) = \dfrac{a \times b}{\text{FPB}(a,b)}$'),
      const TipItem('02', r'Jumlah $1$ s.d. $n$ = $\dfrac{n(n+1)}{2}$. Rumus cepat!'),
      const TipItem('03', r'Luas persegi panjang $= p \times l$. Keliling $= 2(p + l)$.'),
      const TipItem('04', 'FPB: faktor persekutuan terbesar — cari dengan pembagian bertahap.'),
    ],
    'mixed': [
      const TipItem('01', 'Baca soal dua kali: sekali untuk memahami, sekali untuk menjawab.'),
      const TipItem('02', 'Eliminasi dulu pilihan yang jelas salah — persempit ke 2 opsi.'),
      const TipItem('03', 'Kerjakan soal mudah lebih dulu, tandai soal sulit untuk dikerjakan belakangan.'),
      const TipItem('04', 'Estimasi cepat: bulatkan angka dulu untuk cek apakah jawaban masuk akal.'),
      const TipItem('05', 'Jangan terpaku satu soal terlalu lama — waktu TIU sangat terbatas.'),
    ],
  };

  Map<String, String> _categoryLabels = <String, String>{
    'arithmetic': 'Aritmetika',
    'sequence': 'Deret Angka',
    'algebra': 'Aljabar',
    'logic': 'Logika & Geometri',
    'mixed': 'Campuran',
  };

  Map<String, String> _difficultyLabels = <String, String>{
    'easy': 'Mudah',
    'medium': 'Sedang',
    'hard': 'Sulit',
  };

  Map<String, List<TipItem>> get tipsMap => Map.unmodifiable(_tipsMap);
  Map<String, String> get categoryLabels => Map.unmodifiable(_categoryLabels);
  Map<String, String> get difficultyLabels => Map.unmodifiable(_difficultyLabels);

  Future<void> loadTipsFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/data/tips_data.json');
      final data = json.decode(response);

      if (data['tipsMap'] != null) {
        final newTipsMap = <String, List<TipItem>>{};
        data['tipsMap'].forEach((key, value) {
          if (value is List) {
            newTipsMap[key] = value.map((item) {
              return TipItem(
                item['num']?.toString() ?? '',
                item['text']?.toString() ?? '',
              );
            }).toList();
          }
        });
        if (newTipsMap.isNotEmpty) {
          _tipsMap = newTipsMap;
        }
      }

      if (data['categoryLabels'] != null) {
        final newCategoryLabels = <String, String>{};
        data['categoryLabels'].forEach((key, value) {
          newCategoryLabels[key] = value.toString();
        });
        if (newCategoryLabels.isNotEmpty) {
          _categoryLabels = newCategoryLabels;
        }
      }

      if (data['difficultyLabels'] != null) {
        final newDifficultyLabels = <String, String>{};
        data['difficultyLabels'].forEach((key, value) {
          newDifficultyLabels[key] = value.toString();
        });
        if (newDifficultyLabels.isNotEmpty) {
          _difficultyLabels = newDifficultyLabels;
        }
      }
    } catch (e) {
      debugPrint('Error loading tips json: $e');
    }
  }
}
