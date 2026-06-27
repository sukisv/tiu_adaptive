class Question {
  final String text;
  final List<String> opts;
  final String answer;
  final String topic;
  final String tag;
  final String difficulty;
  final String? explanation;

  const Question({
    required this.text,
    required this.opts,
    required this.answer,
    required this.topic,
    required this.tag,
    required this.difficulty,
    this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'] as String,
      opts: (json['opts'] as List).map((e) => e.toString()).toList(),
      answer: json['answer'].toString(),
      topic: json['topic'] as String,
      tag: json['tag'] as String? ?? 'DATABASE',
      difficulty: json['difficulty'] as String,
      explanation: json['explanation'] as String?,
    );
  }
}

class AqgQuestion {
  final String text;
  final List<String> opts;
  final String answer;
  final String topic;
  final String difficulty;
  final String? explanation;

  const AqgQuestion({
    required this.text,
    required this.opts,
    required this.answer,
    required this.topic,
    required this.difficulty,
    this.explanation,
  });
}
