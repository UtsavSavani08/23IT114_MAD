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
        title: '', // Remove title from section for cleaner look
        radius: 60,
        badgeWidget: _buildBadge(entry.value),
        badgePositionPercentageOffset: 1.1,
        showTitle: false,
      );
    }).toList();

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 50,
                  sections: sections,
                  borderData: FlBorderData(show: false),
                ),
                swapAnimationDuration: const Duration(milliseconds: 800),
                swapAnimationCurve: Curves.easeInOutBack,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$total',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const Text(
                    'TOTAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textHint,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: distribution.entries
              .where((entry) => entry.value > 0)
              .map((entry) => _buildLegendItem(entry.key, entry.value))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildBadge(int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$value',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildLegendItem(ApplicationStatus status, int count) {
    final color = _getColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _getLabel(status),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
