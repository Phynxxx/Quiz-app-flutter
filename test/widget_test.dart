// Widget tests for QuizMaster Pro
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/data/question_repository.dart';
import 'package:flutter_application_1/widgets/answer_button.dart';
import 'package:flutter_application_1/widgets/question_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final repository = QuestionRepository();
    repository.reset();
    await repository.initialize();
  });

  testWidgets('App loads and displays splash screen',
      (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MyApp());

    // Let the first frame settle so the loading state can transition to splash
    await tester.pump();

    // Should show splash screen after initialization
    expect(find.byIcon(Icons.bolt), findsOneWidget);

    // Let the splash timer complete so the test finishes with no pending timers
    await tester.pump(
        const Duration(seconds: AppConstants.splashScreenDurationSeconds));
    await tester.pump();

    // Dispose tree to ensure no timers are left running.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('Splash screen transitions to quiz', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pump();
    await tester.pump(
        const Duration(seconds: AppConstants.splashScreenDurationSeconds));
    await tester.pump();

    // After splash duration, should navigate to quiz and show custom answer buttons
    expect(find.byType(AnswerButton), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('Quiz displays question and answers correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pump();
    await tester.pump(
        const Duration(seconds: AppConstants.splashScreenDurationSeconds));
    await tester.pump();

    expect(find.byType(QuestionCard), findsOneWidget);
    expect(find.byType(AnswerButton), findsNWidgets(4));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('Scaffold uses correct theme colors',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeData.darkTheme(),
        home: const Scaffold(),
      ),
    );

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.brightness, Brightness.dark);
  });

  testWidgets('App theme is properly applied', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pump();

    // Verify material app has theme
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme, isNotNull);
    expect(materialApp.theme?.brightness, Brightness.dark);

    await tester.pump(
        const Duration(seconds: AppConstants.splashScreenDurationSeconds));
    await tester.pump();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
