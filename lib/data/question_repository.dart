import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/question.dart';

/// QuestionRepository - Handles loading and managing the question bank
class QuestionRepository {
  static final QuestionRepository _instance = QuestionRepository._internal();
  late List<Question> _allQuestions;
  bool _isInitialized = false;

  QuestionRepository._internal();

  /// Singleton instance
  factory QuestionRepository() {
    return _instance;
  }

  /// Check if questions are loaded
  bool get isInitialized => _isInitialized;

  /// Get all loaded questions
  List<Question> get allQuestions => _allQuestions;

  /// Load all questions from JSON asset file
  /// This should be called once during app startup
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      // Load JSON from assets
      final jsonString =
          await rootBundle.loadString('assets/data/questions.json');

      // Parse JSON into List<Question>
      _allQuestions = parseQuestions(jsonString);

      _isInitialized = true;
      print('✅ Loaded ${_allQuestions.length} questions from database');
    } catch (e) {
      print('❌ Error loading questions: $e');
      rethrow;
    }
  }

  /// Get a randomized list of N questions from the question bank
  /// This is used to create a unique quiz session
  /// Returns [count] random questions from the bank
  List<Question> getRandomizedQuestions(int count) {
    if (!_isInitialized) {
      throw Exception(
          'QuestionRepository not initialized. Call initialize() first.');
    }

    if (count > _allQuestions.length) {
      count = _allQuestions.length;
      print(
          '⚠️ Requested count ($count) exceeds available questions. Using ${_allQuestions.length}');
    }

    // Create a copy and shuffle question order
    final randomQuestions = List<Question>.from(_allQuestions);
    randomQuestions.shuffle();

    // Return the first 'count' questions with shuffled answer order.
    // This prevents the correct option from always being first.
    return randomQuestions.take(count).map((question) {
      final shuffledAnswers = List<Answer>.from(question.answers);
      shuffledAnswers.shuffle();

      return question.copyWith(
        answers: shuffledAnswers,
        hint: _resolveHint(question),
      );
    }).toList();
  }

  String _resolveHint(Question question) {
    if (question.hint != null && question.hint!.trim().isNotEmpty) {
      return question.hint!;
    }

    final correctAnswer = question.answers.firstWhere(
      (answer) => answer.score > 0,
      orElse: () => question.answers.first,
    );

    final firstLetter = correctAnswer.text.isNotEmpty
        ? correctAnswer.text[0].toUpperCase()
        : '?';

    final categoryText = question.category ?? 'General Knowledge';
    return 'Category: $categoryText • The answer starts with "$firstLetter".';
  }

  /// Get questions filtered by category
  /// Useful for future category-based quiz sessions
  List<Question> getQuestionsByCategory(String category, {int? limit}) {
    if (!_isInitialized) {
      throw Exception(
          'QuestionRepository not initialized. Call initialize() first.');
    }

    var filtered = _allQuestions
        .where((q) => q.category?.toLowerCase() == category.toLowerCase())
        .toList();

    if (limit != null && limit < filtered.length) {
      filtered.shuffle();
      filtered = filtered.take(limit).toList();
    }

    return filtered;
  }

  /// Get available categories
  List<String> getCategories() {
    if (!_isInitialized) {
      throw Exception(
          'QuestionRepository not initialized. Call initialize() first.');
    }

    final categories = <String>{};
    for (var question in _allQuestions) {
      if (question.category != null) {
        categories.add(question.category!);
      }
    }
    return categories.toList();
  }

  /// Get statistics about the question bank
  Map<String, dynamic> getStatistics() {
    if (!_isInitialized) {
      throw Exception(
          'QuestionRepository not initialized. Call initialize() first.');
    }

    final categoryCount = <String, int>{};
    for (var question in _allQuestions) {
      final category = question.category ?? 'Uncategorized';
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }

    return {
      'total_questions': _allQuestions.length,
      'categories': getCategories(),
      'category_breakdown': categoryCount,
    };
  }

  /// Reset repository (for testing purposes)
  void reset() {
    _isInitialized = false;
    _allQuestions = [];
  }
}
