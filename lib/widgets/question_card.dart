import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';

/// QuestionCard - Displays a quiz question with consistent PRD styling
class QuestionCard extends StatelessWidget {
  final String questionText;
  final int questionNumber;
  final int totalQuestions;
  final int remainingSeconds;
  final String? hintText;
  final bool showHint;
  final int hintsRemaining;
  final int totalHints;

  const QuestionCard({
    Key? key,
    required this.questionText,
    required this.questionNumber,
    required this.totalQuestions,
    required this.remainingSeconds,
    this.hintText,
    this.showHint = false,
    required this.hintsRemaining,
    required this.totalHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      padding: EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: AppRadius.radiusLg(),
        boxShadow: AppShadows.elevationMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $questionNumber of $totalQuestions',
                style: AppTypography.labelMedium(context),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: remainingSeconds <= 10
                      ? AppColors.accentColor
                      : AppColors.warningColor,
                  borderRadius: AppRadius.radiusFull(),
                ),
                child: Text(
                  '$remainingSeconds s',
                  style: AppTypography.labelMedium(context),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),

          // Question text
          Text(
            questionText,
            style: AppTypography.headlineMedium(context),
          ),

          SizedBox(height: AppSpacing.lg),

          Text(
            'Hints left: $hintsRemaining / $totalHints',
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.subtitleColor,
            ),
          ),

          if (showHint && hintText != null && hintText!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppRadius.radiusMd(),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Text(
                '💡 Hint: $hintText',
                style: AppTypography.bodyMedium(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
