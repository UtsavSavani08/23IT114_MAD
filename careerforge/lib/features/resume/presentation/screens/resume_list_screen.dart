import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../providers/resume_provider.dart';
import '../widgets/resume_card.dart';

class ResumeListScreen extends StatelessWidget {
  const ResumeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myResumes),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.resumeBuilder);
            },
          ),
        ],
      ),
      body: Consumer<ResumeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.resumes.isEmpty) {
            return const LoadingShimmer();
          }

          if (provider.resumes.isEmpty) {
            return EmptyStateWidget(
              message: 'No resumes found',
              subMessage: 'Create your first resume to start applying to jobs.',
              icon: Icons.file_copy_outlined,
              buttonLabel: AppStrings.createResume,
              onButtonPressed: () {
                Navigator.pushNamed(context, AppRoutes.resumeBuilder);
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.resumes.length,
            itemBuilder: (context, index) {
              return ResumeCard(resume: provider.resumes[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'resume_list_fab',
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.resumeBuilder);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
