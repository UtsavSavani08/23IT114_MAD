import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/connectivity_service.dart';
import '../../../application/data/models/application_model.dart';
import '../widgets/stats_card.dart';
import '../widgets/status_chart.dart';
import '../widgets/recent_applications_list.dart';
import '../../../../features/dashboard/providers/dashboard_provider.dart';
import '../../../../core/constants/app_routes.dart';

// Since we are using BottomNavigationBar to switch between major features,
// the DashboardScreen acts as the main shell.
import '../../../resume/presentation/screens/resume_list_screen.dart';
import '../../../application/presentation/screens/search_filter_screen.dart';
// We'll use SearchFilterScreen for applications list

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityService>().isOnline;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: Icon(
              isOnline ? Icons.sync : Icons.cloud_off,
              color: isOnline ? AppColors.success : AppColors.textHint,
            ),
            onPressed: () {
              // Trigger sync logic
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!isOnline)
            Container(
              width: double.infinity,
              color: AppColors.warning,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                AppStrings.offlineMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildDashboardTab(),
                const ResumeListScreen(),
                // For tab 2, it could be a standalone applications list, but we can reuse SearchFilterScreen with no active filters
                const SearchFilterScreen(),
                const SearchFilterScreen(), // Tab 3 is explicitly search
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.applicationEntry);
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: AppStrings.dashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: AppStrings.myResumes,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: AppStrings.applications,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: AppStrings.search,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      label: AppStrings.totalApplications,
                      value: provider.totalApplications.toString(),
                      icon: Icons.list_alt,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatsCard(
                      label: AppStrings.activeApplications,
                      value: provider.activeApplications.toString(),
                      icon: Icons.timelapse,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      label: AppStrings.selected,
                      value: provider.statusDistribution[ApplicationStatus.selected]?.toString() ?? '0',
                      icon: Icons.check_circle_outline,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatsCard(
                      label: AppStrings.successRate,
                      value: '${provider.successRate.toStringAsFixed(1)}%',
                      icon: Icons.pie_chart_outline,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Status Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: StatusChart(distribution: provider.statusDistribution),
              ),
              const SizedBox(height: 32),
              const Text(
                AppStrings.recentApplications,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              RecentApplicationsList(applications: provider.recentApplications),
            ],
          ),
        );
      },
    );
  }
}
