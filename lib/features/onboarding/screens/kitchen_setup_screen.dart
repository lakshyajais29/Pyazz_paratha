import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../dashboard/screens/dashboard_screen.dart'; // Final Destination

class KitchenSetupScreen extends StatefulWidget {
  const KitchenSetupScreen({super.key});

  @override
  State<KitchenSetupScreen> createState() => _KitchenSetupScreenState();
}

class _KitchenSetupScreenState extends State<KitchenSetupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  String _loadingText = "Calculating your BMR...";
  double _progress = 0.0;
  String _subText = "Mapping flavor compounds...";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _startLoadingSequence();
  }

  void _startLoadingSequence() {
    // Sequence of loading states
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

    Timer(const Duration(seconds: 6), () {
      if(mounted) {
         setState(() { _progress = 1.0; });
         // Navigate
         Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
          ), // Simplified icon
          onPressed: () => Navigator.pop(context),
        ),
         title: Text(
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
            // Floating Icons / Central Animation
            SizedBox(
              height: 300,
              width: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Rings (simulated with large containers or custom paint)
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
                    ),
                  ),
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
                    ),
                  ),
                  // Central Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.psychology, size: 60, color: AppColors.primary), // Head/Brain icon
                  ),
                   Positioned(
                    top: 20,
                    left: 40,
                     child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.eco, color: AppColors.primary),
                     ),
                   ),
                    Positioned(
                    bottom: 60,
                    right: 40,
                     child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.local_fire_department, color: AppColors.primary),
                     ),
                   ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            Text(
              _loadingText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'DM Serif Display',
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
             Text(
              _subText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary, // Orange text
              ),
            ),
             const SizedBox(height: 8),
               Text(
              'Curating your recipes...',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),

            const Spacer(flex: 1),

            // Pot Animation (Static for now)
            Icon(Icons.soup_kitchen, size: 64, color: AppColors.primary.withOpacity(0.5)),
            
            const SizedBox(height: 20),
            
            Text(
              '${(_progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Text(
              'PREPARATION IN PROGRESS',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
