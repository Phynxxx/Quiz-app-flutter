import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/data/question_repository.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuestionRepository Tests', () {
    late QuestionRepository repository;

    setUp(() {
      repository = QuestionRepository();
      repository.reset(); // Reset singleton state
    });

    test('Repository initialization loads questions', () async {
      await repository.initialize();

      expect(repository.isInitialized, true);
      expect(repository.allQuestions.length, 100);
    });

    test('getRandomizedQuestions returns correct count', () async {
      await repository.initialize();

      final questions = repository.getRandomizedQuestions(10);
      expect(questions.length, 10);
    });

    test('getRandomizedQuestions returns unique questions in a session',
        () async {
      await repository.initialize();

      final questions = repository.getRandomizedQuestions(10);
      final ids = questions.map((q) => q.id).toList();

      // Check no duplicates within one quiz
      expect(ids.length, ids.toSet().length);
    });

    test('getRandomizedQuestions handles count > bank size', () async {
      await repository.initialize();

      final questions = repository.getRandomizedQuestions(150);
      expect(questions.length, 100); // Should return all available
    });

    test('getQuestionsByCategory filters correctly', () async {
      await repository.initialize();

      final geographyQuestions = repository.getQuestionsByCategory('Geography');
      expect(geographyQuestions.isNotEmpty, true);

      // All should be Geography category
      for (var q in geographyQuestions) {
        expect(q.category, 'Geography');
      }
    });

    test('getCategories returns all available categories', () async {
      await repository.initialize();

      final categories = repository.getCategories();
      expect(categories.length, greaterThan(0));
      expect(categories.contains('Geography'), true);
      expect(categories.contains('Science'), true);
    });

    test('getStatistics returns correct info', () async {
      await repository.initialize();

      final stats = repository.getStatistics();

      expect(stats['total_questions'], 100);
      expect(stats['categories'], isList);
      expect(stats['category_breakdown'], isMap);
    });

    test('Throws exception if not initialized', () {
      repository.reset();

      expect(
        () => repository.getRandomizedQuestions(10),
        throwsException,
      );
    });

    test('Question randomization varies across calls', () async {
      await repository.initialize();

      final first = repository.getRandomizedQuestions(5);
      final second = repository.getRandomizedQuestions(5);

      // Extremely unlikely that 5 random questions from 100 are in same order twice
      final firstIds = first.map((q) => q.id).toList();
      final secondIds = second.map((q) => q.id).toList();

      // At least some should differ
      expect(firstIds != secondIds, true);
    });

    test('Randomized session does not keep all correct answers in first slot',
        () async {
      await repository.initialize();

      final questions = repository.getRandomizedQuestions(10);
      final countWithCorrectFirst = questions
          .where((question) => question.answers.first.score > 0)
          .length;

      // With shuffled answers, it should be very unlikely all 10 have correct answer first.
      expect(countWithCorrectFirst < questions.length, true);
    });

    test('Randomized questions provide non-empty hints', () async {
      await repository.initialize();

      final questions = repository.getRandomizedQuestions(10);
      for (final question in questions) {
        expect(question.hint, isNotNull);
        expect(question.hint!.trim().isNotEmpty, true);
      }
    });
  });
}
