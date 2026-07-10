import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';
import 'generators/generator_utils.dart';
import 'generators/arithmetic_generator.dart';
import 'generators/sequence_generator.dart';
import 'generators/algebra_generator.dart';
import 'generators/logic_generator.dart';

class QuestionService {
  List<Question> _questionDatabase = [];

  Future<void> loadQuestionsFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/data/questions.json');
      final data = json.decode(response) as List<dynamic>;
      _questionDatabase = data.map((item) => Question.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      // ignore
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

    if (matchingDbQuestions.isNotEmpty && (rng.nextDouble() < 0.5 || category == 'verbal_analogy' || category == 'syllogism' || category == 'analytical')) {
      return pick(matchingDbQuestions);
    }

    switch (category) {
      case 'arithmetic':
        return ArithmeticGenerator.generateArithmetic(diff);
      case 'sequence':
        return SequenceGenerator.generateSequence(diff);
      case 'algebra':
        return AlgebraGenerator.generateAlgebra(diff);
      case 'logic':
        return LogicGenerator.generateLogic(diff);
      default:
        if (matchingDbQuestions.isNotEmpty) {
          return pick(matchingDbQuestions);
        }
        final gen = pick([
          ArithmeticGenerator.generateArithmetic,
          SequenceGenerator.generateSequence,
          AlgebraGenerator.generateAlgebra,
          LogicGenerator.generateLogic
        ]);
        return gen(diff);
    }
  }

  // Template counts per category & difficulty (used for maxQuestionCount estimation).
  // Updated to reflect enriched generators:
  //   arithmetic : easy=10, medium=24, hard=40
  //   sequence   : easy=4 (+3 medium-bonus), medium=12, hard=19
  //   algebra    : easy=4,  medium=11, hard=18
  //   logic      : easy=10, medium=22, hard=40
  static const _templateCounts = {
    'arithmetic': {'easy': 10, 'medium': 24, 'hard': 40},
    'sequence':   {'easy': 4,  'medium': 12, 'hard': 19},
    'algebra':    {'easy': 4,  'medium': 11, 'hard': 18},
    'logic':      {'easy': 10, 'medium': 22, 'hard': 40},
  };

  int maxQuestionCount(String category, String difficulty) {
    const multiplier = 3; 

    if (category == 'mixed') {
      int total = 0;
      for (final cat in _templateCounts.keys) {
        total += (_templateCounts[cat]?[difficulty] ?? 0) * multiplier;
      }
      total += _questionDatabase
          .where((q) => q.difficulty == difficulty)
          .length;
      return total;
    }

    final procCount = _templateCounts[category]?[difficulty];
    if (procCount != null) {
      final dbCount = _matchingDbCount(category, difficulty);
      return procCount * multiplier + dbCount;
    }

    return _matchingDbCount(category, difficulty);
  }

  int _matchingDbCount(String category, String difficulty) {
    return _questionDatabase.where((q) {
      final catMatch = category == 'mixed' ||
          (category == 'arithmetic' && (q.topic == 'Aritmetika' || q.topic == 'Arithmetic')) ||
          (category == 'sequence' && (q.topic == 'Deret Angka' || q.topic == 'Sequence')) ||
          (category == 'algebra' && (q.topic == 'Aljabar' || q.topic == 'Algebra')) ||
          (category == 'logic' && (q.topic == 'Logika & Geometri' || q.topic == 'Logic')) ||
          q.topic.toLowerCase() == category.toLowerCase();
      return catMatch && q.difficulty == difficulty;
    }).length;
  }
}
