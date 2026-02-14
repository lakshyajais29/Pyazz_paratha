import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'package:snapdiet/features/onboarding/controller/onboarding_controller.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'features/onboarding/screens/welcome_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart'; // Add this import
import 'core/services/storage_service.dart'; // Add this import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize and load user data
  final controller = OnboardingController();
  await controller.loadUserData();
  
  // Check if onboarding is complete
  final storage = StorageService();
  final isOnboardingComplete = await storage.isOnboardingComplete();

  runApp(SnapDietApp(isOnboardingComplete: isOnboardingComplete));
}

class SnapDietApp extends StatelessWidget {
  final bool isOnboardingComplete;
  const SnapDietApp({super.key, required this.isOnboardingComplete});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapDiet',
      theme: AppTheme.lightTheme,
      // If onboarding is complete, go directly to Dashboard, else Splash/Welcome
      // For now, let's keep Splash as first screen but pass the state to it or decide there
      // Better yet, use 'home' based on state
      home: isOnboardingComplete ? const DashboardScreen() : const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}
