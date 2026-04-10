import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/data/question_repository.dart';
import 'package:flutter_application_1/models/question.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/quiz_screen.dart';
import 'package:flutter_application_1/screens/result_screen.dart';

void main() async {
  // Initialize questions from JSON before running app
  WidgetsFlutterBinding.ensureInitialized();
  final repository = QuestionRepository();
  await repository.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Question> currentQuizQuestions = [];
  int questionIndex = 0;
  int totalScore = 0;
  int hintsUsed = 0;
  bool showSplash = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  void _initializeQuiz() async {
    try {
      final repository = QuestionRepository();

      // Get 10 random questions for this quiz session
      currentQuizQuestions = repository.getRandomizedQuestions(
        AppConstants.questionsPerQuiz,
      );

      // Print statistics
      print('📊 Question Bank Stats:');
      final stats = repository.getStatistics();
      print('Total Questions: ${stats['total_questions']}');
      print('Categories: ${stats['categories']}');

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error initializing quiz: $e');
      setState(() {
        currentQuizQuestions = [];
        isLoading = false;
      });
    }
  }

  void _onSplashComplete() {
    setState(() {
      showSplash = false;
    });
  }

  void _resetQuiz() {
    // Get new randomized questions for next session
    final repository = QuestionRepository();
    currentQuizQuestions = repository.getRandomizedQuestions(
      AppConstants.questionsPerQuiz,
    );

    setState(() {
      questionIndex = 0;
      totalScore = 0;
      hintsUsed = 0;
    });
  }

  bool _useHint() {
    if (hintsUsed >= AppConstants.totalHintsPerQuiz) {
      return false;
    }

    setState(() {
      hintsUsed += 1;
    });

    return true;
  }

  void _answerQuestion(int score) {
    totalScore += score;
    setState(() {
      questionIndex += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizMaster Pro',
      theme: AppThemeData.darkTheme(),
      debugShowCheckedModeBanner: false,
      home: isLoading
          ? Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            )
          : showSplash
              ? SplashScreen(onComplete: _onSplashComplete)
              : Scaffold(
                  body: questionIndex < currentQuizQuestions.length
                      ? QuizScreen(
                          questions: currentQuizQuestions,
                          answerQuestion: _answerQuestion,
                          questionIndex: questionIndex,
                          hintsUsed: hintsUsed,
                          maxHints: AppConstants.totalHintsPerQuiz,
                          onUseHint: _useHint,
                        )
                      : ResultScreen(
                          totalScore: totalScore,
                          maxScore: AppConstants.maxScorePossible,
                          resetQuiz: _resetQuiz,
                        ),
                ),
    );
  }
}
