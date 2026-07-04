import 'package:flutter/foundation.dart';
import '../models/question.dart';
import '../services/service_locator.dart';

class ProcGenViewModel extends ChangeNotifier {
  String _category = 'mixed';
  int _count = 5;
  String _difficulty = 'medium';
  List<Question> _questions = [];
  Map<int, int> _answers = {};
  bool _checked = false;
  bool _generated = false;

  // ── Getters ────────────────────────────────────────────────────
  String get category => _category;
  int get count => _count;
  String get difficulty => _difficulty;
  List<Question> get questions => List.unmodifiable(_questions);
  Map<int, int> get answers => Map.unmodifiable(_answers);
  bool get checked => _checked;
  bool get generated => _generated;

  bool get allAnswered =>
      _questions.isNotEmpty &&
      _questions.asMap().keys.every((i) => _answers.containsKey(i));

  int get correctCount => _questions.asMap().entries.where((e) {
        final correctIdx = e.value.opts.indexWhere((o) => o == e.value.answer);
        return _answers[e.key] == correctIdx;
      }).length;

  int get wrongCount => _questions.length - correctCount;

  // ── Commands ────────────────────────────────────────────────────
  void setCategory(String value) {
    if (_category == value) return;
    _category = value;
    notifyListeners();
  }

  void setCount(int value) {
    if (_count == value) return;
    _count = value;
    notifyListeners();
  }

  void setDifficulty(String value) {
    if (_difficulty == value) return;
    _difficulty = value;
    notifyListeners();
  }

  void generate() {
    final generatedQuestions = <Question>[];
    final seenTexts = <String>{};

    for (int i = 0; i < _count; i++) {
      Question? uniqueQ;
      int attempts = 0;
      while (attempts < 50) {
        final q = serviceLocator.questionService.generateQuestion(_category, _difficulty);
        if (!seenTexts.contains(q.text)) {
          uniqueQ = q;
          break;
        }
        attempts++;
      }

      final q = uniqueQ ?? serviceLocator.questionService.generateQuestion(_category, _difficulty);
      seenTexts.add(q.text);
      generatedQuestions.add(q);
    }

    _questions = generatedQuestions;
    _answers = {};
    _checked = false;
    _generated = true;
    notifyListeners();
  }

  void selectAnswer(int questionIndex, int optionIndex) {
    if (_checked) return;
    _answers = {..._answers, questionIndex: optionIndex};
    notifyListeners();
  }

  void checkAnswers() {
    if (!allAnswered) return;
    _checked = true;
    notifyListeners();
  }

  void reset() => generate();
}
