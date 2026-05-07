import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';

// Import screens (We'll implement these next)
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/resume/presentation/screens/resume_list_screen.dart';
import 'features/resume/presentation/screens/resume_builder_screen.dart';
import 'features/application/presentation/screens/application_entry_screen.dart';
import 'features/application/presentation/screens/application_detail_screen.dart';
import 'features/application/presentation/screens/search_filter_screen.dart';
import 'features/resume/data/models/resume_model.dart';
import 'features/application/data/models/application_model.dart';

class CareerForgeApp extends StatelessWidget {
  const CareerForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.home:
            return _buildPageRoute(const DashboardScreen());
          case AppRoutes.resumeList:
            return _buildPageRoute(const ResumeListScreen());
          case AppRoutes.resumeBuilder:
            final args = settings.arguments as ResumeModel?;
            return _buildPageRoute(ResumeBuilderScreen(resume: args));
          case AppRoutes.applicationEntry:
            final args = settings.arguments as ApplicationModel?;
            return _buildPageRoute(ApplicationEntryScreen(application: args));
          case AppRoutes.applicationDetail:
            final args = settings.arguments as ApplicationModel;
            return _buildPageRoute(ApplicationDetailScreen(application: args));
          case AppRoutes.searchFilter:
            return _buildPageRoute(const SearchFilterScreen());
          default:
            return _buildPageRoute(
              Scaffold(
                appBar: AppBar(title: const Text('404')),
                body: const Center(child: Text('Page not found')),
              ),
            );
        }
      },
    );
  }

  PageRouteBuilder _buildPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
