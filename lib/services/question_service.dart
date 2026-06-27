import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

typedef _QGen = Map<String, dynamic> Function();

class QuestionService {
  final _rng = math.Random();
  List<Question> _questionDatabase = [];

  int _rand(int a, int b) => a + _rng.nextInt(b - a + 1);

  T _pick<T>(List<T> arr) => arr[_rand(0, arr.length - 1)];

  List<T> _shuffle<T>(List<T> arr) {
    final a = [...arr];
    for (int i = a.length - 1; i > 0; i--) {
      final j = _rand(0, i);
      final tmp = a[i];
      a[i] = a[j];
      a[j] = tmp;
    }
    return a;
  }

  int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

  List<num> _makeDistractors(num correct, {int n = 3}) {
    final s = <num>{correct};
    final ops = <num Function(num)>[
      (v) => v + _rand(1, 5),
      (v) => v - _rand(1, 5),
      (v) => v + _rand(6, 15),
      (v) => v - _rand(6, 15),
      (v) => (v * 1.5).round(),
      (v) => (v * 0.75).round(),
      (v) => v + _rand(20, 50),
      (v) => v - _rand(20, 50),
      (v) => v * 2,
      (v) => (v / 2).round(),
    ];
    int tries = 0;
    while (s.length < n + 1 && tries < 80) {
      final c = _pick(ops)(correct);
      if (c != correct && c > 0 && c.isFinite) s.add(c.round());
      tries++;
    }
    int fb = 1;
    while (s.length < n + 1) {
      s.add(correct + fb * 7);
      fb++;
    }
    return _shuffle(s.toList());
  }

  Question _generateArithmetic(String diff) {
    final level = {'easy': 1, 'medium': 2, 'hard': 3}[diff]!;
    final templates = <_QGen>[];

    templates.add(() {
      final ops = ['+', '-', '×'];
      final op = _pick(level >= 2 ? ops : ops.sublist(0, 2));
      int answer;
      String text;
      if (op == '+') {
        final a = _rand(10, 99), b = _rand(10, 99);
        answer = a + b;
        text = 'Berapa hasil dari $a + $b?';
      } else if (op == '-') {
        final a = _rand(10, 99), b = _rand(10, 99);
        final x = math.max(a, b), y = math.min(a, b);
        answer = x - y;
        text = 'Berapa hasil dari $x − $y?';
      } else {
        final a2 = _rand(2, 25), b2 = _rand(2, 12);
        answer = a2 * b2;
        text = 'Berapa hasil dari $a2 × $b2?';
      }
      return {'text': text, 'answer': answer, 'topic': 'Aritmetika'};
    });

    templates.add(() {
      final price = _rand(5, 100) * 10;
      final discountPct = _pick([10, 20, 25, 30, 40, 50]);
      final discountAmount = price * discountPct ~/ 100;
      return {
        'text': 'Sebuah barang seharga Rp${_fmt(price)} didiskon $discountPct%. Harga setelah diskon adalah… (Rp)',
        'answer': price - discountAmount,
        'topic': 'Persentase',
      };
    });

    templates.add(() {
      final percentage = _rand(20, 80), total = _rand(50, 500);
      final portion = (total * percentage / 100).round();
      return {
        'text': '$percentage% dari $total adalah…',
        'answer': portion,
        'topic': 'Persentase',
      };
    });

    if (level >= 2) {
      templates.add(() {
        final speed = _rand(40, 120), time = _rand(2, 6);
        return {
          'text': 'Kendaraan melaju $speed km/jam selama $time jam. Jarak yang ditempuh adalah… km',
          'answer': speed * time,
          'topic': 'Kecepatan',
        };
      });
      templates.add(() {
        final a = _rand(2, 9), b = _rand(2, 9), c = _rand(5, 25);
        return {
          'text': 'Nilai dari $a × $b + $c adalah…',
          'answer': a * b + c,
          'topic': 'Aritmetika',
        };
      });
    }

    if (level >= 3) {
      templates.add(() {
        final x = _rand(3, 12);
        return {
          'text': r'Jika $x = ' '$x\$, maka nilai \$x^2 - 3x + 2\$ adalah…',
          'answer': x * x - 3 * x + 2,
          'topic': 'Aljabar',
        };
      });
    }

    final result = _pick(templates)();
    final opts = _makeDistractors(result['answer'] as num);
    return Question(
      text: result['text'] as String,
      opts: opts.map((o) => o.toString()).toList(),
      answer: (result['answer'] as num).toString(),
      topic: result['topic'] as String,
      tag: 'PROCGEN',
      difficulty: diff,
    );
  }

  Question _generateSequence(String diff) {
    final level = {'easy': 1, 'medium': 2, 'hard': 3}[diff]!;
    final templates = <_QGen>[];

    templates.add(() {
      final a = _rand(1, 20), d = _rand(2, 10);
      final seq = List.generate(5, (i) => a + i * d);
      final answer = a + 5 * d;
      return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Aritmetika'};
    });

    templates.add(() {
      final a = _rand(1, 5), r = _pick([2, 3, 4]);
      final seq = List.generate(4, (i) => a * math.pow(r, i).toInt());
      final answer = a * math.pow(r, 4).toInt();
      return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Geometri'};
    });

    if (level >= 2) {
      templates.add(() {
        final start = _rand(1, 5);
        final seq = List.generate(5, (i) => (start + i) * (start + i));
        final answer = (start + 5) * (start + 5);
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Deret Kuadrat'};
      });

      templates.add(() {
        final a = _rand(1, 6), b = _rand(1, 6);
        final seq = [a, b];
        for (int i = 0; i < 5; i++) { seq.add(seq[seq.length - 1] + seq[seq.length - 2]); }
        final answer = seq[seq.length - 1] + seq[seq.length - 2];
        return {'text': 'Lanjutan dari deret: ${seq.sublist(0, 6).join(', ')}, …?', 'answer': answer, 'topic': 'Deret Fibonacci'};
      });
    }

    if (level >= 3) {
      templates.add(() {
        final a = _rand(2, 10), d = _rand(2, 5);
        final seq = [a];
        for (int i = 0; i < 5; i++) { seq.add(seq.last + d * (i + 1)); }
        final answer = seq.last + d * 6;
        return {'text': 'Lanjutan dari deret: ${seq.join(', ')}, …?', 'answer': answer, 'topic': 'Selisih Bertingkat'};
      });
    }

    final result = _pick(templates)();
    final opts = _makeDistractors(result['answer'] as num);
    return Question(
      text: result['text'] as String,
      opts: opts.map((o) => o.toString()).toList(),
      answer: (result['answer'] as num).toString(),
      topic: result['topic'] as String,
      tag: 'PROCGEN',
      difficulty: diff,
    );
  }

  Question _generateAlgebra(String diff) {
    final level = {'easy': 1, 'medium': 2, 'hard': 3}[diff]!;
    final templates = <_QGen>[];

    templates.add(() {
      final x = _rand(2, 15), b = _rand(1, 20), coeff = level >= 2 ? _rand(2, 5) : 1;
      final rhs = coeff * x + b;
      return {
        'text': r'Jika $' '${coeff == 1 ? "" : coeff}x + $b = $rhs\$, maka \$x =\$ …',
        'answer': x,
        'topic': 'Persamaan Linear',
      };
    });

    templates.add(() {
      final x = _rand(2, 12), y = _rand(1, 10);
      final s = x + y, d = x - y;
      return {
        'text': r'Jika $x + y = ' '$s\$ dan \$x - y = $d\$, maka nilai \$x\$ adalah…',
        'answer': x,
        'topic': 'Sistem Persamaan',
      };
    });

    if (level >= 2) {
      templates.add(() {
        final x = _rand(2, 10);
        return {
          'text': r'Nilai $2x^2 + 3x - 5$ saat $x = ' '$x\$ adalah…',
          'answer': 2 * x * x + 3 * x - 5,
          'topic': 'Aljabar',
        };
      });
    }

    if (level >= 3) {
      templates.add(() {
        final x = _rand(1, 8), y = _rand(1, 8);
        final a = _rand(1, 4), b = _rand(1, 4);
        final eq1 = a * x + b * y;
        final eq2 = x - y;
        return {
          'text': r'Dari $' '$a x + ${b}y = $eq1\$ dan \$x - y = $eq2\$, nilai \$x + y =\$ …',
          'answer': x + y,
          'topic': 'Sistem Persamaan',
        };
      });
    }

    final result = _pick(templates)();
    final opts = _makeDistractors(result['answer'] as num);
    return Question(
      text: result['text'] as String,
      opts: opts.map((o) => o.toString()).toList(),
      answer: (result['answer'] as num).toString(),
      topic: result['topic'] as String,
      tag: 'PROCGEN',
      difficulty: diff,
    );
  }

  Question _generateLogic(String diff) {
    final level = {'easy': 1, 'medium': 2, 'hard': 3}[diff]!;
    final templates = <_QGen>[];

    templates.add(() {
      final a = _rand(4, 30), b = _rand(4, 30);
      final lcm = a * b ~/ _gcd(a, b);
      return {'text': 'KPK dari $a dan $b adalah…', 'answer': lcm, 'topic': 'Faktor & Kelipatan'};
    });

    templates.add(() {
      final n = _rand(4, 12);
      return {'text': 'Jumlah bilangan bulat dari 1 sampai $n adalah…', 'answer': n * (n + 1) ~/ 2, 'topic': 'Penjumlahan Deret'};
    });

    templates.add(() {
      final p = _rand(8, 25), l = _rand(4, 15);
      return {'text': 'Luas persegi panjang dengan panjang $p m dan lebar $l m adalah… m²', 'answer': p * l, 'topic': 'Geometri'};
    });

    if (level >= 2) {
      templates.add(() {
        final r = _rand(5, 20);
        return {
          'text': 'Keliling lingkaran berjari-jari \$r = $r\$ cm \$(\\pi \\approx 3{,}14)\$ adalah… cm',
          'answer': (2 * 3.14 * r).round(),
          'topic': 'Geometri',
        };
      });
      templates.add(() {
        final a = _rand(4, 30), b = _rand(4, 30);
        final g = _gcd(a, b);
        return {'text': 'FPB dari $a dan $b adalah…', 'answer': g, 'topic': 'Faktor & Kelipatan'};
      });
    }

    if (level >= 3) {
      templates.add(() {
        final n = _rand(4, 7);
        final factorial = List.generate(n, (i) => i + 1).fold(1, (a, b) => a * b);
        return {'text': r'Nilai dari $' '$n!\$ ($n faktorial) adalah…', 'answer': factorial, 'topic': 'Faktorial'};
      });
    }

    final result = _pick(templates)();
    final opts = _makeDistractors(result['answer'] as num);
    return Question(
      text: result['text'] as String,
      opts: opts.map((o) => o.toString()).toList(),
      answer: (result['answer'] as num).toString(),
      topic: result['topic'] as String,
      tag: 'PROCGEN',
      difficulty: diff,
    );
  }

  Future<void> loadQuestionsFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/data/questions.json');
      final data = json.decode(response) as List<dynamic>;
      _questionDatabase = data.map((item) => Question.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      // print or ignore
    }
  }

  Question generateQuestion(String category, String diff) {
    var matchingDbQuestions = _questionDatabase.where((q) {
      final catMatch = category == 'mixed' ||
          (category == 'arithmetic' && (q.topic == 'Aritmetika' || q.topic == 'Arithmetic')) ||
          (category == 'sequence' && (q.topic == 'Deret Angka' || q.topic == 'Sequence')) ||
          (category == 'algebra' && (q.topic == 'Aljabar' || q.topic == 'Algebra')) ||
          (category == 'logic' && (q.topic == 'Logika & Geometri' || q.topic == 'Logic')) ||
          q.topic.toLowerCase() == category.toLowerCase();
      
      final diffMatch = diff == q.difficulty;
      return catMatch && diffMatch;
    }).toList();

    // Fallback to matching category regardless of difficulty if no exact match
    if (matchingDbQuestions.isEmpty) {
      matchingDbQuestions = _questionDatabase.where((q) {
        return category == 'mixed' ||
            (category == 'arithmetic' && (q.topic == 'Aritmetika' || q.topic == 'Arithmetic')) ||
            (category == 'sequence' && (q.topic == 'Deret Angka' || q.topic == 'Sequence')) ||
            (category == 'algebra' && (q.topic == 'Aljabar' || q.topic == 'Algebra')) ||
            (category == 'logic' && (q.topic == 'Logika & Geometri' || q.topic == 'Logic')) ||
            q.topic.toLowerCase() == category.toLowerCase();
      }).toList();
    }

    if (matchingDbQuestions.isNotEmpty && (_rng.nextDouble() < 0.5 || category == 'verbal_analogy' || category == 'syllogism' || category == 'analytical')) {
      return _pick(matchingDbQuestions);
    }

    switch (category) {
      case 'arithmetic':
        return _generateArithmetic(diff);
      case 'sequence':
        return _generateSequence(diff);
      case 'algebra':
        return _generateAlgebra(diff);
      case 'logic':
        return _generateLogic(diff);
      default:
        if (matchingDbQuestions.isNotEmpty) {
          return _pick(matchingDbQuestions);
        }
        return _pick([_generateArithmetic, _generateSequence, _generateAlgebra, _generateLogic])(diff);
    }
  }

  String _fmt(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
