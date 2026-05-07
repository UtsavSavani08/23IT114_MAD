import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../application/data/models/application_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class StatusChart extends StatelessWidget {
  final Map<ApplicationStatus, int> distribution;

  const StatusChart({super.key, required this.distribution});

  Color _getColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return AppColors.statusApplied;
      case ApplicationStatus.shortlisted:
        return AppColors.statusShortlisted;
      case ApplicationStatus.interviewScheduled:
        return AppColors.statusInterview;
      case ApplicationStatus.rejected:
        return AppColors.statusRejected;
      case ApplicationStatus.selected:
        return AppColors.statusSelected;
    }
  }

  String _getLabel(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.interviewScheduled:
        return 'Interview';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.selected:
        return 'Selected';
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold(0, (sum, count) => sum + count);

    if (total == 0) {
      return const EmptyStateWidget(
        message: 'No applications yet',
        icon: Icons.pie_chart_outline,
      );
    }

    final sections = distribution.entries
        .where((entry) => entry.value > 0)
        .map((entry) {
      return PieChartSectionData(
        color: _getColor(entry.key),
        value: entry.value.toDouble(),
        title: '${entry.value}',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: sections,
                ),
                swapAnimationDuration: const Duration(milliseconds: 600),
              ),
              Text(
                '$total\nTotal',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: distribution.entries
              .where((entry) => entry.value > 0)
              .map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${_getLabel(entry.key)} (${entry.value})',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
