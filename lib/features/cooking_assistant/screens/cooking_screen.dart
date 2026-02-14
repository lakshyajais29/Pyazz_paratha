import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/recipe_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CookingScreen extends StatefulWidget {
  final Recipe recipe;
  const CookingScreen({super.key, required this.recipe});

  @override
  State<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  int _currentStep = 0;
  bool _isTimerRunning = false;
  int _secondsRemaining = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cooking Assistant', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: AppColors.primary),
            onPressed: () {}, // TTS Placeholder
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: (_currentStep + 1) / widget.recipe.instructions.length,
            backgroundColor: Colors.grey[200],
            progressColor: AppColors.primary,
          ),
          
          Expanded(
            child: PageView.builder(
              itemCount: widget.recipe.instructions.length,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Container(
                         height: 200,
                         width: 200,
                         decoration: BoxDecoration(
                           color: Colors.white,
                           shape: BoxShape.circle,
                           boxShadow: [
                             BoxShadow(
                               color: AppColors.primary.withOpacity(0.1),
                               blurRadius: 20,
                               offset: const Offset(0, 10),
                             ),
                           ],
                         ),
                         child: Center(
                           child: Text(
                             'Step ${index + 1}',
                             style: const TextStyle(
                               fontSize: 40,
                               fontWeight: FontWeight.bold,
                               color: AppColors.primary,
                             ),
                           ),
                         ),
                       ),
                       const SizedBox(height: 40),
                       Text(
                         widget.recipe.instructions[index],
                         textAlign: TextAlign.center,
                         style: const TextStyle(
                           fontSize: 24,
                           fontWeight: FontWeight.bold,
                           fontFamily: 'DM Serif Display',
                           height: 1.3,
                         ),
                       ),
                       const SizedBox(height: 40),
                       
                       // Timer Mockup
                       if (index == 2) // Just showing timer on step 3 for demo
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                           decoration: BoxDecoration(
                             color: AppColors.primary,
                             borderRadius: BorderRadius.circular(30),
                           ),
                           child: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               const Icon(Icons.timer, color: Colors.white),
                               const SizedBox(width: 8),
                               Text(
                                 _isTimerRunning ? '03:45' : 'Start Timer (4 min)',
                                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                               ),
                             ],
                           ),
                         ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Controls
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _currentStep > 0 ? () {} : null, // Logic to swipe back
                ),
                FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  onPressed: () {}, // Mic placeholder
                  child: const Icon(Icons.mic),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _currentStep < widget.recipe.instructions.length - 1 ? () {} : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
