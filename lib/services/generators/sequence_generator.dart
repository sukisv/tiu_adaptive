import 'generator_utils.dart';
import '../../models/question.dart';
import 'dart:math' as math;

class SequenceGenerator {
  static Question generateSequence(String diff) {
    final level = {'easy': 1, 'medium': 2, 'hard': 3}[diff]!;
    final templates = <QGen>[];

    // ──── LEVEL 1: Easy ────

    // 1) Deret aritmetika
    templates.add(() {
      final a = rand(1, 20), d = rand(2, 10);
      final seq = List.generate(5, (i) => a + i * d);
      final answer = a + 5 * d;
      return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Aritmetika'};
    });

    // 2) Deret geometri sederhana
    templates.add(() {
      final a = rand(1, 5), r = pick([2, 3, 4]);
      final seq = List.generate(4, (i) => a * math.pow(r, i).toInt());
      final answer = a * math.pow(r, 4).toInt();
      return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Geometri'};
    });

    // 3) Deret kelipatan (genap/ganjil)
    templates.add(() {
      final start = pick([2, 3, 5, 7]);
      final seq = List.generate(5, (i) => start * (i + 1));
      final answer = start * 6;
      return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Kelipatan'};
    });

    // 4) Deret mundur (descending arithmetic)
    templates.add(() {
      final a = rand(50, 100), d = rand(3, 8);
      final seq = List.generate(5, (i) => a - i * d);
      final answer = a - 5 * d;
      return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Aritmetika'};
    });

    if (level >= 2) {
      // ──── LEVEL 2: Medium ────

      // 5) Deret kuadrat
      templates.add(() {
        final start = rand(1, 5);
        final seq = List.generate(5, (i) => (start + i) * (start + i));
        final answer = (start + 5) * (start + 5);
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Kuadrat'};
      });

      // 6) Deret fibonacci-like
      templates.add(() {
        final a = rand(1, 6), b = rand(1, 6);
        final seq = [a, b];
        for (int i = 0; i < 5; i++) { seq.add(seq[seq.length - 1] + seq[seq.length - 2]); }
        final answer = seq[seq.length - 1] + seq[seq.length - 2];
        return {'text': 'Lanjutan dari deret: ${seq.sublist(0, 6).join(', ')}, …?', 'answer': answer, 'topic': 'Deret Fibonacci'};
      });

      // 7) Deret selisih naik (+2, +4, +6, +8...)
      templates.add(() {
        final a = rand(1, 10);
        final seq = [a];
        for (int i = 1; i <= 5; i++) { seq.add(seq.last + 2 * i); }
        final answer = seq.last + 2 * 6;
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Selisih Bertingkat'};
      });

      // 8) Deret bilangan prima
      templates.add(() {
        final primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47];
        final startIdx = rand(0, 5);
        final seq = primes.sublist(startIdx, startIdx + 5);
        final answer = primes[startIdx + 5];
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Bilangan Prima'};
      });

      // 9) Deret segitiga (triangular numbers)
      templates.add(() {
        final start = rand(1, 3);
        final seq = List.generate(5, (i) {
          final n = start + i;
          return n * (n + 1) ~/ 2;
        });
        final n6 = start + 5;
        final answer = n6 * (n6 + 1) ~/ 2;
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Segitiga'};
      });

      // 10) Deret ×2 +1 (atau ×2 -1)
      templates.add(() {
        final a = rand(1, 5);
        final addend = pick([1, -1, 3]);
        final seq = [a];
        for (int i = 0; i < 4; i++) { seq.add(seq.last * 2 + addend); }
        final answer = seq.last * 2 + addend;
        final label = addend >= 0 ? '×2+$addend' : '×2$addend';
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Pola $label'};
      });

      // 11) Deret beda berganti tanda (+a, -b, +a, -b)
      templates.add(() {
        final a = rand(1, 5);
        final addPos = rand(3, 8);
        final addNeg = rand(1, addPos - 1);
        final seq = [a];
        for (int i = 0; i < 5; i++) {
          seq.add(seq.last + (i.isEven ? addPos : -addNeg));
        }
        final answer = seq.last + (5.isEven ? addPos : -addNeg);
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Selang-seling'};
      });

      // 12) Deret rasio menurun (÷2 setiap kali)
      templates.add(() {
        final start = pick([128, 256, 512, 1024]);
        final seq = List.generate(5, (i) => start ~/ math.pow(2, i).toInt());
        final answer = start ~/ math.pow(2, 5).toInt();
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Geometri'};
      });
    }

    if (level >= 3) {
      // ──── LEVEL 3: Hard ────

      // 11) Selisih bertingkat (difference increases by constant)
      templates.add(() {
        final a = rand(2, 10), d = rand(2, 5);
        final seq = [a];
        for (int i = 0; i < 5; i++) { seq.add(seq.last + d * (i + 1)); }
        final answer = seq.last + d * 6;
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Selisih Bertingkat'};
      });

      // 12) Deret kubik
      templates.add(() {
        final start = rand(1, 3);
        final seq = List.generate(5, (i) {
          final n = start + i;
          return n * n * n;
        });
        final n6 = start + 5;
        final answer = n6 * n6 * n6;
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Kubik'};
      });

      // 13) Deret selang-seling (alternating two patterns)
      templates.add(() {
        final a1 = rand(1, 5), d1 = rand(2, 4);
        final a2 = rand(10, 20), d2 = rand(3, 5);
        final seq = <int>[];
        for (int i = 0; i < 3; i++) {
          seq.add(a1 + i * d1);
          seq.add(a2 + i * d2);
        }
        final answer = a1 + 3 * d1;
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Selang-seling'};
      });

      // 14) Deret faktorial
      templates.add(() {
        int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);
        final seq = List.generate(5, (i) => factorial(i + 1));
        final answer = factorial(6);
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Faktorial'};
      });

      // 15) Deret n² + n
      templates.add(() {
        final seq = List.generate(5, (i) {
          final n = i + 1;
          return n * n + n;
        });
        final answer = 6 * 6 + 6;
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Polinomial'};
      });

      // 16) Deret pangkat 2 minus 1
      templates.add(() {
        final seq = List.generate(5, (i) => math.pow(2, i + 1).toInt() - 1);
        final answer = math.pow(2, 6).toInt() - 1;
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Pangkat'};
      });

      // 17) Deret n² - n (polinomial)
      templates.add(() {
        final seq = List.generate(5, (i) {
          final n = i + 2;
          return n * n - n;
        });
        final answer = 7 * 7 - 7;
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Polinomial'};
      });

      // 18) Deret tiga selang-seling (interleaved triple)
      templates.add(() {
        final a = rand(1, 5), d1 = rand(2, 4);
        final b = rand(10, 20), d2 = rand(3, 6);
        final c = rand(50, 70), d3 = rand(5, 10);
        final seq = <int>[];
        for (int i = 0; i < 2; i++) {
          seq.add(a + i * d1);
          seq.add(b + i * d2);
          seq.add(c + i * d3);
        }
        final answer = a + 2 * d1; // suku ke-7: giliran deret A
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Selang-seling'};
      });

      // 19) Deret pangkat 3
      templates.add(() {
        final seq = List.generate(5, (i) => math.pow(3, i).toInt());
        final answer = math.pow(3, 5).toInt();
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Geometri'};
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
  // ALJABAR — diperkaya
  // ────────────────────────────────────────────────────
}