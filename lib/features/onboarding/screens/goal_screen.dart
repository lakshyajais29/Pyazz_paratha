import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'diet_type_screen.dart'; 
import '../../onboarding/controller/onboarding_controller.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final OnboardingController _controller = OnboardingController();
  late String _selectedGoal;

  @override
  void initState() {
    super.initState();
    _selectedGoal = _controller.goal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
       appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Your Goal', 
          style: TextStyle(color: Colors.grey) 
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // Step Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECIPE TIMELINE', 
                    style: TextStyle(
                      color: AppColors.primary, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 10,
                      letterSpacing: 1.5
                    )
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'Step 3 of 7', 
                    style: TextStyle(
                      color: AppColors.textPrimary, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                    )
                  ),
                  Text(
                    '43%', 
                    style: TextStyle(
                      color: AppColors.primary, 
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Linear Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.43,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 8,
                ),
              ),

              const SizedBox(height: 30),

               Text(
                'What is your goal?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select one to help us tailor your nutrition',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 30),

              // Goal Cards List
              Expanded(
                child: ListView(
                  children: [
                    _buildGoalCard(
                      'Burn Fat',
                      'Metabolic boost with fresh greens',
                      'Weight Loss',
                      Icons.circle_outlined, 
                      'assets/images/food/greens.png', 
                      Colors.green[50]!,
                    ),
                    const SizedBox(height: 16),
                    _buildGoalCard(
                      'Build Muscle',
                      'High protein to fuel your gains',
                      'Strength',
                      Icons.check_circle, 
                      'assets/images/food/protein.png', 
                      Colors.orange[50]!, 
                    ),
                    const SizedBox(height: 16),
                    _buildGoalCard(
                      'Stay Balanced',
                      'The perfect portion for longevity',
                      'Maintenance',
                      Icons.circle_outlined,
                      'assets/images/food/balanced.png', 
                      Colors.pink[50]!,
                    ),
                  ],
                ),
              ),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                   _controller.goal = _selectedGoal;

                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DietTypeScreen(),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue to Step 4'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'You can change your goal at any time in settings.',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard( String title, String description, String category, IconData icon, String assetPath, Color placeholderColor) {
    final isSelected = title == _selectedGoal;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = title;
        });
      },
      child: Container(
        height: 175,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isSelected 
              ? Border.all(color: AppColors.ringYellow, width: 2) // Yellow border for selected
              : Border.all(color: Colors.transparent),
          boxShadow: [
             BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DM Serif Display', // Serif font for titles
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                   const SizedBox(height: 12),
                   Row(
                     children: [
                       Icon(
                         icon, 
                         color: isSelected ? AppColors.ringYellow : AppColors.primary,
                         size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isSelected ? 'Selected' : 'Select Goal',
                           style: TextStyle(
                             fontSize: 12,
                             fontWeight: FontWeight.bold,
                             color: isSelected ? AppColors.ringYellow : AppColors.primary,
                           ),
                        ),
                     ],
                   ),
                ],
              ),
            ),
            // Image Circle
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: placeholderColor, // Placeholder color for missing assets
                ),
                child: const Icon(Icons.image, color: Colors.white54, size: 40), 
                // In real implementation: Image.asset(assetPath) with clipOval
              ),
            ),
          ],
        ),
      ),
    );
  }
}
