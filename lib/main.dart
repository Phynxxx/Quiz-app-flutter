import 'package:flutter/material.dart';
import 'package:flutter_application_1/quiz.dart';
import 'package:flutter_application_1/result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  static const questions = [
    {
      'questionText': 'What is the capital of France?',
      'answers': [
        {'text': 'Paris', 'score': 10},
        {'text': 'London', 'score': 0},
        {'text': 'Berlin', 'score': 0},
        {'text': 'Madrid', 'score': 0},
      ]
    },
    {
      'questionText': 'Which planet is known as the Red Planet?',
      'answers': [
        {'text': 'Mars', 'score': 10},
        {'text': 'Venus', 'score': 0},
        {'text': 'Jupiter', 'score': 0},
        {'text': 'Mercury', 'score': 0},
      ]
    },
    {
      'questionText': 'What is the largest ocean on Earth?',
      'answers': [
        {'text': 'Pacific Ocean', 'score': 10},
        {'text': 'Atlantic Ocean', 'score': 0},
        {'text': 'Indian Ocean', 'score': 0},
        {'text': 'Arctic Ocean', 'score': 0},
      ]
    },
    {
      'questionText': 'Who wrote "Romeo and Juliet"?',
      'answers': [
        {'text': 'William Shakespeare', 'score': 10},
        {'text': 'Charles Dickens', 'score': 0},
        {'text': 'Mark Twain', 'score': 0},
        {'text': 'Jane Austen', 'score': 0},
      ]
    },
    {
      'questionText': 'Which language is used to build Flutter apps?',
      'answers': [
        {'text': 'Dart', 'score': 10},
        {'text': 'Python', 'score': 0},
        {'text': 'Java', 'score': 0},
        {'text': 'Swift', 'score': 0},
      ]
    },
  ];
  var questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    questionIndex += 1;
    _totalScore += score;
    setState(() {});
    if (questionIndex < questions.length) {
      print("Answer Chosen!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('My First App'),
        backgroundColor: const Color(0xFF2196F3),
        shadowColor: const Color(0xFF0000FF),
      ),
      body: questionIndex < questions.length
          ? Quiz(
              questions: questions,
              answerQuestion: _answerQuestion,
              questionIndex: questionIndex,
            )
          : Result(_totalScore, _resetQuiz),
    ));
  }
}
