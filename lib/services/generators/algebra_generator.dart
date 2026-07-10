import 'generator_utils.dart';
import '../../models/question.dart';
import 'dart:math' as math;

class AlgebraGenerator {
  static Question generateAlgebra(String diff) {
    final level = {'easy': 1, 'medium': 2, 'hard': 3}[diff]!;
    final templates = <QGen>[];

    // ──── LEVEL 1: Easy ────

    // 1) Persamaan linear satu variabel
    templates.add(() {
      final x = rand(2, 15), b = rand(1, 20), coeff = level >= 2 ? rand(2, 5) : 1;
      final rhs = coeff * x + b;
      return {
        'text': r'Jika $' '${coeff == 1 ? "" : coeff}x + $b = $rhs\$, maka \$x =\$ …',
        'answer': x,
        'topic': 'Persamaan Linear',
      };
    });

    // 2) Sistem persamaan (eliminasi)
    templates.add(() {
      final x = rand(2, 12), y = rand(1, 10);
      final s = x + y, d = x - y;
      return {
        'text': r'Jika $x + y = ' '$s\$ dan \$x - y = $d\$, maka nilai \$x\$ adalah…',
        'answer': x,
        'topic': 'Sistem Persamaan',
      };
    });

    // 3) Soal cerita: bilangan
    templates.add(() {
      final x = rand(5, 30);
      final coeff = rand(2, 5);
      final addend = rand(3, 15);
      final result = coeff * x + addend;
      return {
        'text': 'Suatu bilangan jika dikalikan $coeff kemudian ditambah $addend hasilnya $result. Bilangan tersebut adalah…',
        'answer': x,
        'topic': 'Persamaan Linear',
      };
    });

    // 4) Substitusi sederhana
    templates.add(() {
      final x = rand(1, 10);
      final answer = 3 * x + 7;
      return {
        'text': r'Jika $x = ' '$x\$, maka nilai \$3x + 7\$ adalah…',
        'answer': answer,
        'topic': 'Substitusi',
      };
    });

    if (level >= 2) {
      // ──── LEVEL 2: Medium ────

      // 5) Evaluasi ekspresi kuadrat
      templates.add(() {
        final x = rand(2, 10);
        return {
          'text': r'Nilai $2x^2 + 3x - 5$ saat $x = ' '$x\$ adalah…',
          'answer': 2 * x * x + 3 * x - 5,
          'topic': 'Aljabar',
        };
      });

      // 6) Jumlah akar persamaan kuadrat (Vieta)
      templates.add(() {
        final x1 = rand(1, 8), x2 = rand(1, 8);
        final b = -(x1 + x2); // x² + bx + c = 0 → jumlah akar = -b
        final c = x1 * x2;
        return {
          'text': r'Jika $x^2' '${b >= 0 ? " + $b" : " - ${-b}"}x + $c = 0\$, maka jumlah kedua akar adalah…',
          'answer': x1 + x2,
          'topic': 'Persamaan Kuadrat',
        };
      });

      // 7) Hasil kali akar (Vieta)
      templates.add(() {
        final x1 = rand(1, 6), x2 = rand(1, 6);
        final sum = x1 + x2;
        final product = x1 * x2;
        return {
          'text': r'Persamaan kuadrat $x^2 - ' '${sum}x + $product = 0\$ memiliki hasil kali akar = …',
          'answer': product,
          'topic': 'Persamaan Kuadrat',
        };
      });

      // 8) Soal cerita SPLDV (harga barang)
      templates.add(() {
        final bookPrice = rand(3, 8) * 1000;
        final penPrice = rand(1, 3) * 1000;
        final qty1Book = rand(2, 5), qty1Pen = rand(1, 4);
        final qty2Book = rand(1, 3), qty2Pen = rand(2, 6);
        final total1 = qty1Book * bookPrice + qty1Pen * penPrice;
        final total2 = qty2Book * bookPrice + qty2Pen * penPrice;
        return {
          'text': 'Harga $qty1Book buku dan $qty1Pen pensil Rp${fmt(total1)}. Harga $qty2Book buku dan $qty2Pen pensil Rp${fmt(total2)}. Harga 1 buku adalah…',
          'answer': bookPrice,
          'topic': 'Sistem Persamaan',
        };
      });

      // 9) Pangkat (eksponen)
      templates.add(() {
        final base = pick([2, 3, 5]);
        final exp = rand(2, 5);
        final answer = math.pow(base, exp).toInt();
        return {
          'text': r'Nilai dari $' '$base^$exp\$ adalah…',
          'answer': answer,
          'topic': 'Eksponen',
        };
      });

      // 10) Sifat eksponen
      templates.add(() {
        final base = pick([2, 3]);
        final a = rand(2, 4), b = rand(1, 3);
        final answer = math.pow(base, a + b).toInt();
        return {
          'text': r'Nilai dari $' '$base^$a × $base^$b\$ adalah…',
          'answer': answer,
          'topic': 'Eksponen',
        };
      });

      // 11) Persamaan ax - b = c
      templates.add(() {
        final x = rand(3, 15);
        final a = rand(2, 6);
        final b = rand(5, 20);
        final rhs = a * x - b;
        return {
          'text': r'Jika $' '${a}x - $b = $rhs\$, maka \$x =\$ …',
          'answer': x,
          'topic': 'Persamaan Linear',
        };
      });
    }

    if (level >= 3) {
      // ──── LEVEL 3: Hard ────

      // 12) SPLDV mencari x+y
      templates.add(() {
        final x = rand(1, 8), y = rand(1, 8);
        final a = rand(1, 4), b = rand(1, 4);
        final eq1 = a * x + b * y;
        final eq2 = x - y;
        return {
          'text': r'Dari $' '$a x + ${b}y = $eq1\$ dan \$x - y = $eq2\$, nilai \$x + y =\$ …',
          'answer': x + y,
          'topic': 'Sistem Persamaan',
        };
      });

      // 13) Persamaan kuadrat — diskriminan
      templates.add(() {
        final x1 = rand(2, 8), x2 = rand(2, 8);
        // (x - x1)(x - x2) = x² - (x1+x2)x + x1*x2
        final sum = x1 + x2;
        final product = x1 * x2;
        final disc = sum * sum - 4 * product;
        return {
          'text': r'Diskriminan dari $x^2 - ' '${sum}x + $product = 0\$ adalah…',
          'answer': disc,
          'topic': 'Persamaan Kuadrat',
        };
      });

      // 14) Evaluasi f(a) - f(b)
      templates.add(() {
        final a = rand(3, 8), b = rand(1, a - 1);
        final fA = a * a + 2 * a;
        final fB = b * b + 2 * b;
        return {
          'text': r'Jika $f(x) = x^2 + 2x$, maka $f(' '$a) - f($b)\$ = …',
          'answer': fA - fB,
          'topic': 'Fungsi',
        };
      });

      // 15) Logaritma sederhana
      templates.add(() {
        final base = pick([2, 3, 5, 10]);
        final exp = rand(2, 4);
        final value = math.pow(base, exp).toInt();
        return {
          'text': 'Nilai dari log basis $base dari $value adalah…',
          'answer': exp,
          'topic': 'Logaritma',
        };
      });

      // 16) Invers fungsi
      templates.add(() {
        final a = rand(2, 5);
        final b = rand(1, 10);
        final y = rand(5, 30);
        // f(x) = ax + b → f⁻¹(y) = (y - b) / a
        // pastikan habis dibagi
        final x = (y - b);
        if (x % a != 0) {
          // adjust y agar habis
          final adjustedY = a * rand(2, 8) + b;
          final adjustedAnswer = (adjustedY - b) ~/ a;
          return {
            'text': r'Jika $f(x) = ' '${a}x + $b\$, maka \$f^{-1}($adjustedY)\$ = …',
            'answer': adjustedAnswer,
            'topic': 'Fungsi Invers',
          };
        }
        return {
          'text': r'Jika $f(x) = ' '${a}x + $b\$, maka \$f^{-1}($y)\$ = …',
          'answer': x ~/ a,
          'topic': 'Fungsi Invers',
        };
      });

      // 17) Barisan aritmetika — cari suku ke-n
      templates.add(() {
        final a = rand(2, 10);
        final d = rand(2, 6);
        final n = rand(10, 20);
        final answer = a + (n - 1) * d;
        return {
          'text': 'Suku ke-$n dari barisan aritmetika $a, ${a + d}, ${a + 2 * d}, … adalah…',
          'answer': answer,
          'topic': 'Barisan Aritmetika',
        };
      });

      // 18) Jumlah n suku pertama deret aritmetika
      templates.add(() {
        final a = rand(1, 5);
        final d = rand(2, 4);
        final n = rand(8, 15);
        final seriesSum = n * (2 * a + (n - 1) * d) ~/ 2;
        return {
          'text': 'Jumlah $n suku pertama barisan $a, ${a + d}, ${a + 2 * d}, … adalah…',
          'answer': seriesSum,
          'topic': 'Deret Aritmetika',
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

  // ─────────────────────────────────────────────────────
  // LOGIKA & GEOMETRI — diperkaya
  // ────────────────────────────────────────────────────
}