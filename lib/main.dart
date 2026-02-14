import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'package:snapdiet/features/onboarding/controller/onboarding_controller.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'features/onboarding/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize and load user data
  await OnboardingController().loadUserData();

  runApp(const SnapDietApp());
}

class SnapDietApp extends StatelessWidget {
  const SnapDietApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapDiet',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
