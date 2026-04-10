import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/question.dart';

void main() {
  group('Question Model Tests', () {
    test('Question.fromJson deserializes correctly', () {
      final json = {
        'id': 1,
        'questionText': 'What is 2 + 2?',
        'category': 'Math',
        'answers': [
          {'text': '4', 'score': 10},
          {'text': '5', 'score': 0},
        ]
      };

      final question = Question.fromJson(json);

      expect(question.id, 1);
      expect(question.questionText, 'What is 2 + 2?');
      expect(question.category, 'Math');
      expect(question.answers.length, 2);
      expect(question.answers[0].text, '4');
      expect(question.answers[0].score, 10);
    });

    test('Answer.fromJson deserializes correctly', () {
      final json = {'text': 'Correct Answer', 'score': 10};
      final answer = Answer.fromJson(json);

      expect(answer.text, 'Correct Answer');
      expect(answer.score, 10);
    });

    test('Question.toJson serializes correctly', () {
      final question = Question(
        id: 1,
        questionText: 'Test Question',
        answers: [
          Answer(text: 'Answer 1', score: 10),
          Answer(text: 'Answer 2', score: 0),
        ],
        category: 'Test',
      );

      final json = question.toJson();

      expect(json['id'], 1);
      expect(json['questionText'], 'Test Question');
      expect(json['category'], 'Test');
      expect(json['answers'].length, 2);
    });

    test('parseQuestions parses JSON array correctly', () {
      final jsonString = '''
      [
        {
          "id": 1,
          "questionText": "Question 1",
          "category": "Geography",
          "answers": [
            {"text": "Answer A", "score": 10},
            {"text": "Answer B", "score": 0}
          ]
        },
        {
          "id": 2,
          "questionText": "Question 2",
          "category": "History",
          "answers": [
            {"text": "Answer X", "score": 10},
            {"text": "Answer Y", "score": 0}
          ]
        }
      ]
      ''';

      final questions = parseQuestions(jsonString);

      expect(questions.length, 2);
      expect(questions[0].id, 1);
      expect(questions[1].id, 2);
    });
  });
}
