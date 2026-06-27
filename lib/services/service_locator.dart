import 'question_service.dart';
import 'tips_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  late final QuestionService questionService;
  late final TipsService tipsService;

  Future<void> init() async {
    questionService = QuestionService();
    tipsService = TipsService();

    // Load any async initial data here
    await Future.wait([
      questionService.loadQuestionsFromJson(),
      tipsService.loadTipsFromJson(),
    ]);
  }
}

// Global accessor for convenience
final serviceLocator = ServiceLocator();
