import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/models/question.dart';
import 'package:flutter_application_1/widgets/question_card.dart';
import 'package:flutter_application_1/widgets/answer_button.dart';

/// QuizScreen - Main quiz display with question and answer options
class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final int questionIndex;
  final Function(int) answerQuestion;
  final int hintsUsed;
  final int maxHints;
  final bool Function() onUseHint;

  const QuizScreen({
    Key? key,
    required this.questions,
    required this.questionIndex,
    required this.answerQuestion,
    required this.hintsUsed,
    required this.maxHints,
    required this.onUseHint,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  int? selectedAnswerIndex;
  bool showHint = false;
  bool isQuestionLocked = false;
  int remainingSeconds = AppConstants.questionTimerSeconds;
  Timer? _questionTimer;
  Timer? _autoHintTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: AppConstants.fadeInDurationMs),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _startQuestionTimers();
  }

  @override
  void didUpdateWidget(QuizScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionIndex != widget.questionIndex) {
      selectedAnswerIndex = null;
      showHint = false;
      isQuestionLocked = false;
      remainingSeconds = AppConstants.questionTimerSeconds;
      _fadeController.reset();
      _fadeController.forward();
      _startQuestionTimers();
    }
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    _autoHintTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _startQuestionTimers() {
    _questionTimer?.cancel();
    _autoHintTimer?.cancel();

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || selectedAnswerIndex != null || isQuestionLocked) {
        timer.cancel();
        return;
      }

      if (remainingSeconds <= 1) {
        timer.cancel();
        _handleTimeExpired();
      } else {
        setState(() {
          remainingSeconds -= 1;
        });
      }
    });

    _autoHintTimer = Timer(
      const Duration(seconds: AppConstants.hintAutoRevealSeconds),
      () {
        if (!mounted || selectedAnswerIndex != null || isQuestionLocked || showHint) {
          return;
        }

        _attemptToShowHint();
      },
    );
  }

  void _attemptToShowHint() {
    final granted = widget.onUseHint();
    if (!granted) {
      return;
    }

    setState(() {
      showHint = true;
    });
  }

  void _handleTimeExpired() {
    if (selectedAnswerIndex != null || isQuestionLocked) {
      return;
    }

    setState(() {
      isQuestionLocked = true;
      remainingSeconds = 0;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      widget.answerQuestion(0);
    });
  }

  void _selectAnswer(int answerIndex, Question question) {
    if (selectedAnswerIndex != null || isQuestionLocked) return;

    _questionTimer?.cancel();
    _autoHintTimer?.cancel();

    setState(() {
      selectedAnswerIndex = answerIndex;
    });

    // Brief delay to show selection feedback before moving to next question
    Future.delayed(Duration(milliseconds: 500), () {
      widget.answerQuestion(
        question.answers[answerIndex].score,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[widget.questionIndex];
    final showAnswerResult = selectedAnswerIndex != null || isQuestionLocked;
    final hintsRemaining = widget.maxHints - widget.hintsUsed;
    final timerProgress = remainingSeconds / AppConstants.questionTimerSeconds;

    return Container(
      color: AppColors.backgroundColor,
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Question Card
                  QuestionCard(
                    questionText: currentQuestion.questionText,
                    questionNumber: widget.questionIndex + 1,
                    totalQuestions: widget.questions.length,
                    remainingSeconds: remainingSeconds,
                    hintText: currentQuestion.hint,
                    showHint: showHint,
                    hintsRemaining: hintsRemaining,
                    totalHints: widget.maxHints,
                  ),

                  SizedBox(height: AppSpacing.xxxl),

                  // Timer indicator
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: LinearProgressIndicator(
                        value: timerProgress,
                        minHeight: 8,
                        backgroundColor: AppColors.surfaceColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          remainingSeconds <= 10
                              ? AppColors.accentColor
                              : AppColors.warningColor,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Manual hint action (if still available)
                  if (!showHint)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: (hintsRemaining <= 0 || showAnswerResult)
                              ? null
                              : _attemptToShowHint,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.borderColor),
                            foregroundColor: AppColors.onBackground,
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.lg,
                            ),
                          ),
                          child: Text(
                            hintsRemaining > 0
                                ? 'Use Hint ($hintsRemaining left)'
                                : 'No hints left',
                            style: AppTypography.bodyMedium(context),
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: AppSpacing.lg),

                  // Answer Buttons
                  Column(
                    children: List.generate(
                      currentQuestion.answers.length,
                      (index) => AnswerButton(
                        answerText: currentQuestion.answers[index].text,
                        onPressed: () => _selectAnswer(index, currentQuestion),
                        isSelected: selectedAnswerIndex == index,
                        isCorrect: currentQuestion.answers[index].score == 10,
                        showResult: showAnswerResult,
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  // Progress Indicator
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: LinearProgressIndicator(
                        value: (widget.questionIndex + 1) /
                            widget.questions.length,
                        minHeight: 4,
                        backgroundColor: AppColors.surfaceColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
