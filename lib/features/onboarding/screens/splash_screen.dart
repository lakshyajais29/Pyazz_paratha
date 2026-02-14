import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'welcome_screen.dart'; // Navigate to Welcome

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading for 3 seconds then navigate
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Floating Food Images (Mockup with colors/icons)
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      left: 20,
                      child: _buildFloatingImage(Colors.redAccent, Icons.apple), // Tomato/Apple
                    ),
                    Positioned(
                      top: 80,
                      right: 30,
                      child: _buildFloatingImage(Colors.green, Icons.eco), // Avocado
                    ),
                    Positioned(
                      bottom: 60,
                      left: 40,
                      child: _buildFloatingImage(Colors.red[900]!, Icons.local_fire_department), // Chili
                    ),
                    Positioned(
                      bottom: 40,
                      right: 60,
                      child: _buildFloatingImage(Colors.yellow, Icons.wb_sunny), // Lemon
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Logo Text
              Text(
                'SnapDiet',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DM Serif Display',
                  color: AppColors.textPrimary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              
              // Tagline
              Text(
                'Cook Smart. Eat Right. Feel Alive.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
              ),
              
              const Spacer(),
              
              // Loading Bar
              Container(
                height: 8,
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(50), // Updated for Flutter 3.27+ withAlpha expects int 0-255
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100, // 50% loaded
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SETTING UP YOUR KITCHEN',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '...',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '© 2024 SNAPDIET LABS',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingImage(Color color, IconData icon) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25), // Updated opacity
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, color: color, size: 40),
      ),
    );
  }
}
