import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';

/// AnswerButton - Individual answer option with feedback animations
class AnswerButton extends StatefulWidget {
  final String answerText;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;

  const AnswerButton({
    Key? key,
    required this.answerText,
    required this.onPressed,
    this.isSelected = false,
    this.isCorrect = false,
    this.showResult = false,
  }) : super(key: key);

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: Duration(milliseconds: AppConstants.scaleTapDurationMs),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (widget.showResult) {
      if (widget.isCorrect) {
        return AppColors.successColor;
      } else if (widget.isSelected) {
        return AppColors.accentColor;
      }
    }
    if (widget.isSelected && !widget.showResult) {
      return AppColors.primaryColor;
    }
    return AppColors.surfaceColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.sm,
      ),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.showResult
                ? null
                : () {
                    _scaleController.forward().then((_) {
                      _scaleController.reverse();
                    });
                    widget.onPressed();
                  },
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 1,
                ),
                boxShadow: widget.isSelected && !widget.showResult
                    ? AppShadows.elevationMd
                    : AppShadows.elevationSm,
              ),
              child: Text(
                widget.answerText,
                style: AppTypography.bodyLarge(context),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
