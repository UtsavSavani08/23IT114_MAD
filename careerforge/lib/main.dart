import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/hive_service.dart';
import 'core/utils/connectivity_service.dart';
import 'features/resume/providers/resume_provider.dart';
import 'features/application/providers/application_provider.dart';
import 'features/dashboard/providers/dashboard_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await HiveService.init();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  final connectivityService = ConnectivityService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: connectivityService),
        ChangeNotifierProvider(create: (_) => ResumeProvider()..loadResumes()),
        ChangeNotifierProvider(create: (_) => ApplicationProvider()..loadApplications()),
        ChangeNotifierProxyProvider<ApplicationProvider, DashboardProvider>(
          create: (context) => DashboardProvider(context.read<ApplicationProvider>()),
          update: (context, appProvider, dashboard) => 
            dashboard ?? DashboardProvider(appProvider),
        ),
      ],
      child: const CareerForgeApp(),
    ),
  );
}
