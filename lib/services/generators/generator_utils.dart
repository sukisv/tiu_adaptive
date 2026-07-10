import 'dart:math' as math;
import '../../models/question.dart';

final math.Random rng = math.Random();

/// Returns a random integer between [min] and [max] (inclusive).
int rand(int min, int max) {
  return min + rng.nextInt(max - min + 1);
}

/// Returns a random element from the [list].
T pick<T>(List<T> list) {
  return list[rng.nextInt(list.length)];
}

/// Computes the greatest common divisor.
int gcd(int a, int b) => b == 0 ? a : gcd(b, a % b);

/// Generates distractors for multiple choice options.
List<num> makeDistractors(num correct, {int n = 3}) {
  final s = <num>{correct};
  final ops = <num Function(num)>[
    (v) => v + rand(1, 5),
    (v) => v - rand(1, 5),
    (v) => v + rand(6, 15),
    (v) => v - rand(6, 15),
    (v) => (v * 1.5).round(),
    (v) => (v * 0.75).round(),
    (v) => v + rand(20, 50),
    (v) => v - rand(20, 50),
    (v) => v * 2,
    (v) => (v / 2).round(),
  ];
  int tries = 0;
  while (s.length < n + 1 && tries < 80) {
    final c = pick(ops)(correct);
    if (c != correct && c > 0 && c.isFinite) s.add(c.round());
    tries++;
  }
  int fb = 1;
  while (s.length < n + 1) {
    s.add(correct + fb * 7);
    fb++;
  }
  final l = s.toList();
  l.shuffle(rng);
  return l;
}

/// Formats an integer to string with dot as thousand separator.
String fmt(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

/// Helper method to create a Question object from generated map
Question buildQuestion(Map<String, dynamic> data, String diff, String fallbackTopic) {
  final answerStr = data['answer'].toString();
  List<String> opts = [];
  if (data.containsKey('opts')) {
    opts = List<String>.from(data['opts']);
  } else {
    final answerInt = num.tryParse(answerStr);
    if (answerInt != null) {
      final distractors = makeDistractors(answerInt, n: 3);
      opts = distractors.map((e) => e.toString()).toList();
    } else {
      opts = [answerStr, 'A', 'B', 'C']..shuffle(rng); // Fallback
    }
  }

  return Question(
    text: data['text'] as String,
    opts: opts,
    answer: answerStr,
    explanation: data['explanation'] as String? ?? 'Pembahasan tidak tersedia.',
    topic: data['topic'] as String? ?? fallbackTopic,
    tag: 'PROCGEN',
    difficulty: diff,
  );
}

typedef QGen = Map<String, dynamic> Function();
