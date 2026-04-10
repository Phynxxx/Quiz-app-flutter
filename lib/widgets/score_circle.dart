import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';

/// ScoreCircle - Displays the final quiz score with color-coded performance indicator
class ScoreCircle extends StatelessWidget {
  final int score;
  final int maxScore;

  const ScoreCircle({
    Key? key,
    required this.score,
    required this.maxScore,
  }) : super(key: key);

  /// Get background color based on score performance
  /// Success (≥50%): Green, Warning (30-49%): Orange, Fail (<30%): Red
  Color _getScoreColor() {
    final percentage = (score / maxScore) * 100;

    if (percentage >= 50) {
      return AppColors.successColor;
    } else if (percentage >= 30) {
      return AppColors.warningColor;
    } else {
      return AppColors.accentColor;
    }
  }

  /// Get performance message based on score
  String _getPerformanceMessage() {
    final percentage = (score / maxScore) * 100;

    if (percentage >= 50) {
      return 'Passed!';
    } else {
      return 'Try Again';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Quiz Score: $score out of $maxScore',
      button: false,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getScoreColor(),
          boxShadow: AppShadows.elevationLg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              score.toString(),
              style: AppTypography.displayLarge(context).copyWith(
                color: AppColors.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '/ $maxScore',
              style: AppTypography.labelMedium(context).copyWith(
                color: AppColors.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
