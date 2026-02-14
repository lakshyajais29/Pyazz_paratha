import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'goal_screen.dart';
import '../../onboarding/controller/onboarding_controller.dart';

class HealthConditionScreen extends StatefulWidget {
  const HealthConditionScreen({super.key});

  @override
  State<HealthConditionScreen> createState() => _HealthConditionScreenState();
}

class _HealthConditionScreenState extends State<HealthConditionScreen> {
  final OnboardingController _controller = OnboardingController();
  final List<String> _selectedConditions = [];

  final List<Map<String, dynamic>> _conditions = [
    {'name': 'Diabetes', 'icon': Icons.water_drop, 'color': Colors.orange},
    {'name': 'Blood Pressure', 'icon': Icons.favorite, 'color': Colors.redAccent},
    {'name': 'Thyroid', 'icon': Icons.face, 'color': Colors.pinkAccent},
    {'name': 'PCOS', 'icon': Icons.fitness_center, 'color': Colors.purpleAccent}, 
    {'name': 'Cholesterol', 'icon': Icons.fastfood, 'color': Colors.amber}, 
    {'name': 'Joint Issues', 'icon': Icons.accessibility, 'color': Colors.brown},
  ];

  @override
  void initState() {
    super.initState();
    _selectedConditions.addAll(_controller.healthConditions);
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
        title: Text(
          'NOURISHAI', 
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14, 
            letterSpacing: 2,
            fontWeight: FontWeight.bold
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
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
                  _buildStepIcon(Icons.restaurant_menu, "PREP", false), // Past
                  Expanded(child: Divider(color: AppColors.primary, thickness: 2)),
                  _buildStepIcon(Icons.kitchen, "COOKING", true), // Current
                  Expanded(child: Divider(color: Colors.grey[300], thickness: 2)),
                  _buildStepIcon(Icons.dinner_dining, "SERVE", false), // Future
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STEP 2 OF 3', 
                    style: TextStyle(
                      color: AppColors.primary, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 10,
                      letterSpacing: 1.5
                    )
                  ),
                  Text(
                    '66% Complete', 
                    style: TextStyle(
                      color: Colors.grey, 
                      fontSize: 10
                    )
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Title
              Text(
                'Any health conditions we should know?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This helps us filter ingredients that could affect your condition and tailor your nutritional profile.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _conditions.length,
                  itemBuilder: (context, index) {
                    final condition = _conditions[index];
                    final isSelected = _selectedConditions.contains(condition['name']);
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedConditions.remove(condition['name']);
                          } else {
                            _selectedConditions.add(condition['name']);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey[200]!,
                            width: 1,
                          ),
                          boxShadow: [
                             if (!isSelected)
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align left as per mockup
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              condition['icon'], 
                              color: isSelected ? Colors.white : condition['color'],
                              size: 28,
                            ),
                            Text(
                              condition['name'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // None Option
               GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedConditions.clear();
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                       SizedBox(width: 8),
                       Text(
                         'None of the above',
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: AppColors.textPrimary
                         ),
                       ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                  _controller.healthConditions = _selectedConditions;
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoalScreen(),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue to My Plan'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIcon(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Icon(icon, color: isActive ? AppColors.primary : Colors.grey),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 8, 
            fontWeight: FontWeight.bold,
            color: isActive ? AppColors.primary : Colors.grey,
          ),
        ),
      ],
    );
  }
}
