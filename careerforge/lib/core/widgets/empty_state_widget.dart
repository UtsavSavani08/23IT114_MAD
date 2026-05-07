import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'custom_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData? icon;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subMessage,
    this.icon,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 80,
                color: AppColors.textHint.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (subMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                subMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: CustomButton(
                  label: buttonLabel!,
                  onPressed: onButtonPressed,
                  icon: Icons.add,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
