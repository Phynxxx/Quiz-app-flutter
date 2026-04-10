import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/widgets/score_circle.dart';

/// ResultScreen - Displays quiz results with score and pass/fail status
class ResultScreen extends StatelessWidget {
  final int totalScore;
  final int maxScore;
  final VoidCallback resetQuiz;

  const ResultScreen({
    Key? key,
    required this.totalScore,
    required this.maxScore,
    required this.resetQuiz,
  }) : super(key: key);

  /// Determine pass/fail and color based on score percentage
  bool _isPassed() {
    final percentage = (totalScore / maxScore) * 100;
    return percentage >= 50;
  }

  Color _getMessageColor() {
    return _isPassed() ? AppColors.successColor : AppColors.accentColor;
  }

  String _getResultMessage() {
    if (_isPassed()) {
      return 'Congratulations!';
    } else {
      return 'Keep Practicing!';
    }
  }

  String _getScorePercentage() {
    final percentage = (totalScore / maxScore) * 100;
    return percentage.toStringAsFixed(0) + '%';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Score Circle
                  ScoreCircle(
                    score: totalScore,
                    maxScore: maxScore,
                  ),

                  SizedBox(height: AppSpacing.xxxl),

                  // Result Message
                  Text(
                    _getResultMessage(),
                    style: AppTypography.headlineLarge(context).copyWith(
                      color: _getMessageColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Score Percentage
                  Text(
                    'You scored ${_getScorePercentage()}',
                    style: AppTypography.titleMedium(context),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  // Detailed Score
                  Container(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: AppShadows.elevationMd,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Correct',
                              style: AppTypography.labelMedium(context),
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              '${totalScore ~/ 10}',
                              style: AppTypography.headlineMedium(context)
                                  .copyWith(
                                color: AppColors.successColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: AppColors.borderColor,
                        ),
                        Column(
                          children: [
                            Text(
                              'Total',
                              style: AppTypography.labelMedium(context),
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              '${AppConstants.questionsPerQuiz}',
                              style: AppTypography.headlineMedium(context)
                                  .copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.xxxl),

                  // Restart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: resetQuiz,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.lg,
                        ),
                        child: Text(
                          'Take Quiz Again',
                          style: AppTypography.buttonText(context),
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
