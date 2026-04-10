import 'dart:convert';

/// Answer model class - represents a single answer option
class Answer {
  final String text;
  final int
      score; // Score awarded for selecting this answer (typically 0 or 10)

  Answer({
    required this.text,
    required this.score,
  });

  /// Factory constructor for JSON deserialization
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['text'] as String,
      score: json['score'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'score': score,
    };
  }

  @override
  String toString() => 'Answer(text: $text, score: $score)';
}

/// Question model class - represents a single quiz question
class Question {
  final int id;
  final String questionText;
  final List<Answer> answers;
  final String? category; // Optional category for future filtering
  final String? hint;

  Question({
    required this.id,
    required this.questionText,
    required this.answers,
    this.category,
    this.hint,
  });

  /// Factory constructor for JSON deserialization
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      questionText: json['questionText'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((answer) => Answer.fromJson(answer as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String?,
      hint: json['hint'] as String?,
    );
  }

  Question copyWith({
    int? id,
    String? questionText,
    List<Answer>? answers,
    String? category,
    String? hint,
  }) {
    return Question(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      answers: answers ?? this.answers,
      category: category ?? this.category,
      hint: hint ?? this.hint,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'category': category,
      'hint': hint,
    };
  }

  @override
  String toString() =>
      'Question(id: $id, text: $questionText, category: $category)';
}

/// Helper function to parse JSON string into List<Question>
List<Question> parseQuestions(String jsonString) {
  final jsonData = jsonDecode(jsonString) as List<dynamic>;
  return jsonData
      .map((question) => Question.fromJson(question as Map<String, dynamic>))
      .toList();
}
