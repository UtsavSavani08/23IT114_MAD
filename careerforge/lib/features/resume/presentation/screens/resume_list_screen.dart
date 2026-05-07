import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../providers/resume_provider.dart';
import '../widgets/resume_card.dart';

class ResumeListScreen extends StatelessWidget {
  const ResumeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          AppStrings.myResumes,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add_rounded, color: AppColors.primary),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.resumeBuilder);
              },
            ),
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
              subMessage: 'Create your first professional resume to stand out and land your dream job.',
              icon: Icons.description_outlined,
              buttonLabel: AppStrings.createResume,
              onButtonPressed: () {
                Navigator.pushNamed(context, AppRoutes.resumeBuilder);
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: provider.resumes.length,
            itemBuilder: (context, index) {
              return ResumeCard(resume: provider.resumes[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'resume_list_fab',
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.resumeBuilder);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create New', style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
