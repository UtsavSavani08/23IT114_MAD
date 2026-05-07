import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../application/data/models/application_model.dart';
import '../../../application/presentation/widgets/application_card.dart';

class RecentApplicationsList extends StatelessWidget {
  final List<ApplicationModel> applications;

  const RecentApplicationsList({super.key, required this.applications});

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) {
      return const EmptyStateWidget(
        message: 'No recent applications',
        icon: Icons.work_outline,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        return ApplicationCard(application: applications[index]);
      },
    );
  }
}
