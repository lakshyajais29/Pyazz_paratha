import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../dashboard/screens/dashboard_screen.dart'; // Final Destination
import '../controller/onboarding_controller.dart';

class KitchenSetupScreen extends StatefulWidget {
  const KitchenSetupScreen({super.key});

  @override
  State<KitchenSetupScreen> createState() => _KitchenSetupScreenState();
}

class _KitchenSetupScreenState extends State<KitchenSetupScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  
  String _loadingText = "Calculating your BMR...";
  double _progress = 0.0;
  String _subText = "Mapping flavor compounds...";

  @override
  void initState() {
    super.initState();
    
    // Pulsing animation for circles (inward/outward)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotation animation for floating icons
    _rotateController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _startLoadingSequence();
  }

  void _startLoadingSequence() {
    Timer(const Duration(milliseconds: 100), () {
      if(mounted) setState(() { _progress = 0.1; });
    });

    Timer(const Duration(seconds: 2), () {
      if(mounted) {
        setState(() {
          _loadingText = "Analyzing preferences...";
          _subText = "Curating your recipes...";
          _progress = 0.45;
        });
      }
    });

    Timer(const Duration(seconds: 4), () {
      if(mounted) {
        setState(() {
          _loadingText = "Setting up kitchen...";
          _subText = "Finalizing your plan...";
          _progress = 0.75;
        });
      }
    });

    Timer(const Duration(seconds: 6), () async {
      if(mounted) {
        setState(() { _progress = 1.0; });
        
        // Save user data and mark onboarding as complete
        await OnboardingController().saveUserData();

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.orange[50], 
            child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20)
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Setting Up Your Kitchen', 
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Animated Floating Icons & Pulsing Circles
            SizedBox(
              height: 300,
              width: 300,
              child: AnimatedBuilder(
                animation: Listenable.merge([_pulseAnimation, _rotateAnimation]),
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer Ring — pulsing outward
                      Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.15),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      // Middle Ring — pulsing inward (inverse)
                      Transform.scale(
                        scale: 2.0 - _pulseAnimation.value, // When outer goes out, middle goes in
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      // Inner Ring — pulsing outward (same as outer but smaller)
                      Transform.scale(
                        scale: _pulseAnimation.value * 0.95,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      // Central glow
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.15),
                              AppColors.primary.withOpacity(0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // Central Icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                        child: const Icon(Icons.psychology, size: 50, color: AppColors.primary),
                      ),
                      // Floating icon 1 — orbiting (eco/leaf)
                      Transform.translate(
                        offset: Offset(
                          130 * cos(_rotateAnimation.value),
                          130 * sin(_rotateAnimation.value),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.eco, color: AppColors.primary, size: 20),
                        ),
                      ),
                      // Floating icon 2 — orbiting opposite direction (fire)
                      Transform.translate(
                        offset: Offset(
                          120 * cos(_rotateAnimation.value + pi),
                          120 * sin(_rotateAnimation.value + pi),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.local_fire_department, color: AppColors.primary, size: 20),
                        ),
                      ),
                      // Floating icon 3 — orbiting at 90° offset (nutrition)
                      Transform.translate(
                        offset: Offset(
                          100 * cos(_rotateAnimation.value + pi / 2),
                          100 * sin(_rotateAnimation.value + pi / 2),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.restaurant, color: AppColors.primary, size: 16),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            
            const SizedBox(height: 40),

            // Loading text
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _loadingText,
                key: ValueKey(_loadingText),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DM Serif Display',
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _subText,
                key: ValueKey(_subText),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),

            const Spacer(flex: 1),

            // Animated pot icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, sin(value * pi * 4) * 4),
                  child: child,
                );
              },
              child: Icon(Icons.soup_kitchen, size: 64, color: AppColors.primary.withOpacity(0.5)),
            ),
            
            const SizedBox(height: 20),
            
            // Progress percentage
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: _progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Column(
                  children: [
                    Text(
                      '${(value * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'PREPARATION IN PROGRESS',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    Container(
                      width: 200,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, Color(0xFFFF8A50)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
