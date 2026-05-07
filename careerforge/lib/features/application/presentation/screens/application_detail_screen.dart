import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/application_model.dart';
import '../../providers/application_provider.dart';
import '../../../resume/providers/resume_provider.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    // We watch the provider so the screen updates if the application changes
    final provider = context.watch<ApplicationProvider>();
    final currentApp = provider.applications.firstWhere(
      (a) => a.applicationId == application.applicationId,
      orElse: () => application,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.applicationEntry,
                arguments: currentApp,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context, currentApp),
            const SizedBox(height: 24),
            _buildStatusSection(context, currentApp),
            const SizedBox(height: 24),
            _buildInfoRow(
              'Date Applied',
              DateFormatter.formatDate(currentApp.dateApplied),
              Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Last Updated',
              DateFormatter.formatDate(currentApp.lastUpdated),
              Icons.update,
            ),
            if (currentApp.jobUrl.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoRow(
                'Job Link',
                currentApp.jobUrl,
                Icons.link,
              ),
            ],
            const SizedBox(height: 24),
            _buildResumeCard(context, currentApp.resumeId),
            const SizedBox(height: 24),
            if (currentApp.notes.isNotEmpty) ...[
              const Text(
                'Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(currentApp.notes),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, ApplicationModel app) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                app.companyName.isNotEmpty ? app.companyName[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.jobRole,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    app.companyName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${app.applicationId}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, ApplicationModel app) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Status',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            StatusBadge(status: app.status),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showStatusUpdateSheet(context, app),
          icon: const Icon(Icons.update),
          label: const Text('Update'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cardBg,
            foregroundColor: AppColors.primary,
            elevation: 0,
            side: const BorderSide(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textHint),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResumeCard(BuildContext context, String resumeId) {
    final resumeProvider = context.read<ResumeProvider>();
    final resume = resumeProvider.getResumeById(resumeId);

    if (resume == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resume Used',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.description, color: AppColors.primary),
            title: Text(resume.profileName),
            subtitle: Text('Updated ${DateFormatter.formatDate(resume.updatedAt)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.resumeBuilder, arguments: resume);
            },
          ),
        ),
      ],
    );
  }

  void _showStatusUpdateSheet(BuildContext context, ApplicationModel app) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Update Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...ApplicationStatus.values.map((status) {
                  return ListTile(
                    title: StatusBadge(status: status),
                    trailing: app.status == status ? const Icon(Icons.check, color: AppColors.primary) : null,
                    onTap: () {
                      context.read<ApplicationProvider>().updateStatus(app.applicationId, status);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
