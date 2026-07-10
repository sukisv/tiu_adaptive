import 'generator_utils.dart';
import '../../models/question.dart';
import 'dart:math' as math;

class LogicGenerator {
  static Question generateLogic(String diff) {
    final level = {'easy': 1, 'medium': 2, 'hard': 3}[diff]!;
    final templates = <QGen>[];

    // ──── LEVEL 1: Easy ────

    // 1) KPK
    templates.add(() {
      final a = rand(4, 30), b = rand(4, 30);
      final lcm = a * b ~/ gcd(a, b);
      return {'text': 'KPK dari $a dan $b adalah…', 'answer': lcm, 'topic': 'Faktor & Kelipatan'};
    });

    // 2) Jumlah 1..n
    templates.add(() {
      final n = rand(4, 12);
      return {'text': 'Jumlah bilangan bulat dari 1 sampai $n adalah…', 'answer': n * (n + 1) ~/ 2, 'topic': 'Penjumlahan Deret'};
    });

    // 3) Luas persegi panjang
    templates.add(() {
      final p = rand(8, 25), l = rand(4, 15);
      return {'text': 'Luas persegi panjang dengan panjang $p m dan lebar $l m adalah… m²', 'answer': p * l, 'topic': 'Geometri'};
    });

    // 4) Keliling persegi
    templates.add(() {
      final s = rand(3, 20);
      return {'text': 'Keliling persegi dengan sisi $s cm adalah… cm', 'answer': 4 * s, 'topic': 'Geometri'};
    });

    // 5) Luas persegi
    templates.add(() {
      final s = rand(3, 15);
      return {'text': 'Luas persegi dengan sisi $s cm adalah… cm²', 'answer': s * s, 'topic': 'Geometri'};
    });

    // 6) Keliling persegi panjang
    templates.add(() {
      final p = rand(5, 20), l = rand(3, 12);
      return {'text': 'Keliling persegi panjang dengan panjang $p cm dan lebar $l cm adalah… cm', 'answer': 2 * (p + l), 'topic': 'Geometri'};
    });

    // 7) Luas segitiga
    templates.add(() {
      final base = rand(4, 20);
      final height = rand(4, 20);
      // ensure result is a whole number
      final evenBase = base % 2 == 0 ? base : base + 1;
      final answer = evenBase * height ~/ 2;
      return {'text': 'Luas segitiga dengan alas $evenBase cm dan tinggi $height cm adalah… cm²', 'answer': answer, 'topic': 'Geometri'};
    });

    // 8) Bilangan ganjil / genap
    templates.add(() {
      final n = rand(10, 50);
      final countEven = n ~/ 2;
      return {'text': 'Banyaknya bilangan genap dari 1 sampai $n adalah…', 'answer': countEven, 'topic': 'Bilangan'};
    });

    // 9) [Easy] FPB sederhana
    templates.add(() {
      final a = rand(4, 20), b = rand(4, 20);
      final g = gcd(a, b);
      return {'text': 'FPB dari $a dan $b adalah…', 'answer': g, 'topic': 'Faktor & Kelipatan'};
    });

    // 10) [Easy] Luas belah ketupat
    templates.add(() {
      final diag1 = rand(4, 14) * 2; // even for whole result
      final diag2 = rand(4, 12) * 2;
      final area = diag1 * diag2 ~/ 2;
      return {'text': 'Luas belah ketupat dengan diagonal $diag1 cm dan $diag2 cm adalah… cm²', 'answer': area, 'topic': 'Geometri'};
    });

    if (level >= 2) {
      // ──── LEVEL 2: Medium ────

      // 11) Keliling lingkaran
      templates.add(() {
        final r = rand(5, 20);
        return {
          'text': 'Keliling lingkaran berjari-jari r = $r cm (π ≈ 3,14) adalah… cm',
          'answer': (2 * 3.14 * r).round(),
          'topic': 'Geometri',
        };
      });

      // 12) Luas lingkaran
      templates.add(() {
        final r = pick([7, 14, 21]);
        final area = (22 * r * r) ~/ 7;
        return {
          'text': 'Luas lingkaran berjari-jari $r cm (π = 22/7) adalah… cm²',
          'answer': area,
          'topic': 'Geometri',
        };
      });

      // 13) Volume kubus
      templates.add(() {
        final s = rand(3, 10);
        return {'text': 'Volume kubus dengan rusuk $s cm adalah… cm³', 'answer': s * s * s, 'topic': 'Geometri Ruang'};
      });

      // 14) Volume balok
      templates.add(() {
        final p = rand(4, 12), l = rand(3, 8), t = rand(2, 6);
        return {'text': 'Volume balok dengan panjang $p cm, lebar $l cm, dan tinggi $t cm adalah… cm³', 'answer': p * l * t, 'topic': 'Geometri Ruang'};
      });

      // 15) Luas permukaan kubus
      templates.add(() {
        final s = rand(3, 10);
        return {'text': 'Luas permukaan kubus dengan rusuk $s cm adalah… cm²', 'answer': 6 * s * s, 'topic': 'Geometri Ruang'};
      });

      // 16) Luas trapesium
      templates.add(() {
        final a = rand(8, 15); // min 8 so b can be rand(3, a-2)
        final b = rand(3, a - 2);
        final t = rand(4, 10);
        final area = (a + b) * t ~/ 2;
        return {'text': 'Luas trapesium dengan sisi sejajar $a cm dan $b cm serta tinggi $t cm adalah… cm²', 'answer': area, 'topic': 'Geometri'};
      });

      // 17) Sudut segitiga — FIX: pastikan a+b < 180 dan c > 0
      templates.add(() {
        final a = rand(30, 70);
        final b = rand(20, math.min(70, 150 - a)); // a + b pasti < 170 → c >= 10
        final c = 180 - a - b;
        return {'text': 'Jika dua sudut segitiga adalah $a° dan $b°, maka sudut ketiga adalah… °', 'answer': c, 'topic': 'Geometri'};
      });

      // 18) Peluang dadu
      templates.add(() {
        final target = pick([1, 2, 3, 4, 5]);
        final count = 6 - target;
        return {'text': 'Sebuah dadu dilempar. Banyaknya kemungkinan muncul angka lebih dari $target adalah…', 'answer': count, 'topic': 'Peluang'};
      });

      // 19) Diagonal persegi panjang (Pythagoras)
      templates.add(() {
        final triplets = [[3, 4, 5], [5, 12, 13], [6, 8, 10], [8, 15, 17], [9, 12, 15]];
        final t = pick(triplets);
        return {
          'text': 'Panjang diagonal persegi panjang dengan panjang ${t[0]} cm dan lebar ${t[1]} cm adalah… cm',
          'answer': t[2],
          'topic': 'Geometri (Pythagoras)',
        };
      });

      // 20) Luas jajar genjang
      templates.add(() {
        final base = rand(5, 15), height = rand(3, 10);
        return {'text': 'Luas jajar genjang dengan alas $base cm dan tinggi $height cm adalah… cm²', 'answer': base * height, 'topic': 'Geometri'};
      });

      // 21) [Medium] Kelipatan persekutuan — soal cerita
      templates.add(() {
        final a = pick([3, 4, 5, 6]);
        final b = pick([4, 6, 8, 10]);
        final lcm = a * b ~/ gcd(a, b);
        return {
          'text': 'Lampu A menyala setiap $a menit, lampu B menyala setiap $b menit. Keduanya menyala bersama pada menit ke-0. Kapan keduanya menyala bersama lagi untuk pertama kali?',
          'answer': lcm,
          'topic': 'Faktor & Kelipatan',
        };
      });

      // 22) [Medium] Peluang bola dari kantong
      templates.add(() {
        final red = rand(3, 8);
        final blue = rand(3, 8);
        final totalBalls = red + blue;
        return {
          'text': 'Sebuah kantong berisi $red bola merah dan $blue bola biru. Banyaknya cara memilih 1 bola merah dari $totalBalls bola adalah…',
          'answer': red,
          'topic': 'Peluang',
        };
      });
    }

    if (level >= 3) {
      // ──── LEVEL 3: Hard ────

      // 23) Faktorial — FIX: ganti raw string yang rusak
      templates.add(() {
        final n = rand(4, 7);
        final factorial = List.generate(n, (i) => i + 1).fold(1, (a, b) => a * b);
        return {'text': 'Nilai dari $n! ($n faktorial) adalah…', 'answer': factorial, 'topic': 'Faktorial'};
      });

      // 24) Volume tabung
      templates.add(() {
        final r = pick([7, 14]);
        final t = rand(5, 15);
        final volume = (22 * r * r * t) ~/ 7;
        return {'text': 'Volume tabung berjari-jari $r cm dan tinggi $t cm (π = 22/7) adalah… cm³', 'answer': volume, 'topic': 'Geometri Ruang'};
      });

      // 25) Luas permukaan balok
      templates.add(() {
        final p = rand(4, 10), l = rand(3, 8), t = rand(2, 6);
        final surfaceArea = 2 * (p * l + p * t + l * t);
        return {'text': 'Luas permukaan balok dengan ukuran $p × $l × $t cm adalah… cm²', 'answer': surfaceArea, 'topic': 'Geometri Ruang'};
      });

      // 26) Garis pelukis kerucut (Pythagoras)
      templates.add(() {
        final triplets = [[7, 24, 25], [5, 12, 13], [3, 4, 5], [8, 15, 17]];
        final t = pick(triplets);
        return {
          'text': 'Panjang garis pelukis kerucut berjari-jari ${t[0]} cm dan tinggi ${t[1]} cm adalah… cm',
          'answer': t[2],
          'topic': 'Geometri Ruang',
        };
      });

      // 27) Permutasi
      templates.add(() {
        final n = rand(4, 7), r = rand(2, math.min(3, n));
        int perm = 1;
        for (int i = 0; i < r; i++) { perm *= (n - i); }
        return {'text': 'Nilai dari P($n, $r) = $n! / ($n−$r)! adalah…', 'answer': perm, 'topic': 'Permutasi'};
      });

      // 28) Kombinasi
      templates.add(() {
        final n = rand(5, 10), r = rand(2, 3);
        int perm = 1, rFact = 1;
        for (int i = 0; i < r; i++) { perm *= (n - i); rFact *= (i + 1); }
        final comb = perm ~/ rFact;
        return {'text': 'Nilai dari C($n, $r) = $n! / ($r! × ($n−$r)!) adalah…', 'answer': comb, 'topic': 'Kombinasi'};
      });

      // 29) Peluang 2 dadu
      templates.add(() {
        final target = pick([5, 6, 7, 8, 9]);
        int count = 0;
        for (int i = 1; i <= 6; i++) {
          for (int j = 1; j <= 6; j++) {
            if (i + j == target) count++;
          }
        }
        return {
          'text': 'Dua dadu dilempar bersamaan. Banyaknya kombinasi yang jumlahnya = $target adalah… dari 36 kemungkinan',
          'answer': count,
          'topic': 'Peluang',
        };
      });

      // 30) Modular / sisa pembagian
      templates.add(() {
        final a = rand(50, 200), b = rand(3, 13);
        final remainder = a % b;
        return {'text': 'Sisa pembagian $a dibagi $b adalah…', 'answer': remainder, 'topic': 'Aritmetika Modular'};
      });

      // 31) Bilangan biner — jumlah digit 1
      templates.add(() {
        final n = rand(10, 63);
        int count = 0;
        int tmp = n;
        while (tmp > 0) { count += tmp & 1; tmp >>= 1; }
        return {'text': 'Banyaknya digit 1 pada representasi biner dari $n adalah…', 'answer': count, 'topic': 'Sistem Bilangan'};
      });

      // 32) Volume bola
      templates.add(() {
        final r = pick([7, 14, 21]);
        final volume = (4 * 22 * r * r * r) ~/ (3 * 7);
        return {'text': 'Volume bola berjari-jari $r cm (π = 22/7) adalah… cm³', 'answer': volume, 'topic': 'Geometri Ruang'};
      });

      // 33) Teorema Pythagoras — cari sisi
      templates.add(() {
        final triplets = [[3, 4, 5], [5, 12, 13], [6, 8, 10], [8, 15, 17], [9, 12, 15], [7, 24, 25]];
        final t = pick(triplets);
        final askHyp = rng.nextBool();
        if (askHyp) {
          return {
            'text': 'Sebuah segitiga siku-siku memiliki sisi tegak ${t[0]} cm dan ${t[1]} cm. Panjang sisi miringnya adalah… cm',
            'answer': t[2],
            'topic': 'Teorema Pythagoras',
          };
        } else {
          return {
            'text': 'Sebuah segitiga siku-siku memiliki sisi miring ${t[2]} cm dan sisi tegak ${t[0]} cm. Panjang sisi tegak lainnya adalah… cm',
            'answer': t[1],
            'topic': 'Teorema Pythagoras',
          };
        }
      });

      // 34) [Hard] Volume kerucut
      templates.add(() {
        final r = pick([7, 14]);
        final t = rand(6, 18);
        // V = 1/3 × π × r² × t
        final volume = (22 * r * r * t) ~/ (3 * 7);
        return {'text': 'Volume kerucut berjari-jari $r cm dan tinggi $t cm (π = 22/7) adalah… cm³', 'answer': volume, 'topic': 'Geometri Ruang'};
      });

      // 35) [Hard] Luas permukaan tabung (tanpa tutup)
      templates.add(() {
        final r = pick([7, 14]);
        final t = rand(5, 15);
        // Lateral area = 2πrt, base = πr²
        // Total (with top + bottom) = 2πr(r + t)
        final surfaceArea = (2 * 22 * r * (r + t)) ~/ 7;
        return {'text': 'Luas permukaan tabung tertutup berjari-jari $r cm dan tinggi $t cm (π = 22/7) adalah… cm²', 'answer': surfaceArea, 'topic': 'Geometri Ruang'};
      });

      // 36) [Hard] Clock arithmetic
      templates.add(() {
        final startHour = rand(6, 20);
        final startMin = pick([0, 15, 30, 45]);
        final durationMin = rand(1, 5) * 30 + rand(0, 1) * 15;
        final totalMin = startHour * 60 + startMin + durationMin;
        final startHourStr = startHour.toString().padLeft(2, '0');
        final startMinStr = startMin.toString().padLeft(2, '0');
        return {
          'text': 'Sebuah acara dimulai pukul $startHourStr.$startMinStr dan berlangsung selama $durationMin menit. Acara berakhir pada menit ke-… dihitung dari tengah malam (misal pukul 13.30 = 810 menit)',
          'answer': totalMin % (24 * 60),
          'topic': 'Pengukuran Waktu',
        };
      });

      // 37) [Hard] Luas permukaan bola
      templates.add(() {
        final r = pick([7, 14]);
        // L = 4πr²
        final surfaceArea = (4 * 22 * r * r) ~/ 7;
        return {'text': 'Luas permukaan bola berjari-jari $r cm (π = 22/7) adalah… cm²', 'answer': surfaceArea, 'topic': 'Geometri Ruang'};
      });

      // 38) [Hard] Perimeter + area — combined problem
      templates.add(() {
        final s = rand(3, 12);
        final perimeter = 4 * s;
        final area = s * s;
        return {
          'text': 'Keliling suatu persegi adalah $perimeter cm. Luas persegi tersebut adalah… cm²',
          'answer': area,
          'topic': 'Geometri',
        };
      });

      // 39) [Hard] Peluang kartu (angka ganjil dari 1-10)
      templates.add(() {
        // Kartu bernomor 1-10, ambil 1 kartu. Peluang dapat angka prima = ?
        // Angka prima: 2, 3, 5, 7 → 4 kartu
        return {
          'text': 'Dari kartu bernomor 1 sampai 10, satu kartu diambil secara acak. Banyaknya kartu bernomor prima adalah…',
          'answer': 4, // 2, 3, 5, 7
          'topic': 'Peluang',
        };
      });

      // 40) [Hard] Diagonal ruang balok
      templates.add(() {
        // Pilih dimensi dengan diagonal bulat: 1,2,2 → √9=3; 2,4,4→√36=6; 1,2,14→tidak bagus
        // Gunakan: p=2, l=4, t=4 → d=√(4+16+16)=√36=6; atau p=1,l=2,t=2→√9=3
        final combos = [
          [1, 2, 2, 3],
          [2, 4, 4, 6],
          [2, 6, 9, 11], // 4+36+81=121=11²
          [6, 6, 7, 11], // 36+36+49=121=11²
          [3, 4, 12, 13], // 9+16+144=169=13²
        ];
        final c = pick(combos);
        return {
          'text': 'Panjang diagonal ruang balok dengan ukuran ${c[0]} × ${c[1]} × ${c[2]} cm adalah… cm',
          'answer': c[3],
          'topic': 'Geometri Ruang',
        };
      });
    }

    final result = pick(templates)();
    final opts = makeDistractors(result['answer'] as num);
    return Question(
      text: result['text'] as String,
      opts: opts.map((o) => o.toString()).toList(),
      answer: (result['answer'] as num).toString(),
      topic: result['topic'] as String,
      tag: 'PROCGEN',
      difficulty: diff,
    );
  }
}