import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../../features/application/data/models/application_model.dart';

class StatusBadge extends StatelessWidget {
  final ApplicationStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case ApplicationStatus.applied:
        color = AppColors.statusApplied;
        label = 'Applied';
        break;
      case ApplicationStatus.shortlisted:
        color = AppColors.statusShortlisted;
        label = 'Shortlisted';
        break;
      case ApplicationStatus.interviewScheduled:
        color = AppColors.statusInterview;
        label = 'Interview';
        break;
      case ApplicationStatus.rejected:
        color = AppColors.statusRejected;
        label = 'Rejected';
        break;
      case ApplicationStatus.selected:
        color = AppColors.statusSelected;
        label = 'Selected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
