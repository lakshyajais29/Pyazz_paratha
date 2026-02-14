import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/meal_plan_model.dart';
import '../../../core/models/recipe_model.dart';
import '../../../core/services/recipe_service.dart';
import '../../recipe_suggest/screens/recipe_detail_screen.dart';
import '../../onboarding/controller/onboarding_controller.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final RecipeService _recipeService = RecipeService();
  bool _isLoading = true;
  MealPlanResponse? _mealPlanResponse;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMealPlan();
  }

  Future<void> _fetchMealPlan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Use dynamic preferences from OnboardingController
      final dietType = OnboardingController().dietType.toLowerCase();
      final excludes = OnboardingController().getExcludeIngredients();
      final excludeCategories = OnboardingController().getExcludeCategories();
      
      // Calculate calorie range (simple logic for now, could be BMR based)
      int minCals = 1500;
      int maxCals = 2500;
      if (OnboardingController().goal == 'Lose Weight') {
        minCals = 1200;
        maxCals = 1800;
      } else if (OnboardingController().goal == 'Gain Muscle') {
        minCals = 2200;
        maxCals = 3200;
      }

      final response = await _recipeService.generateMealPlan(
        dietType: dietType.isEmpty ? 'balanced' : dietType,
        days: 7,
        minCalories: minCals,
        maxCalories: maxCals,
        excludeIngredients: excludes,
      );

      if (mounted) {
        setState(() {
          _mealPlanResponse = response;
          _isLoading = false;
          if (response == null) {
            _errorMessage = 'Failed to generate meal plan.';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'An error occurred: $e';
        });
      }
    }
  }

  void _navigateToRecipe(BuildContext context, Meal meal) {
    // Create a temporary Recipe object to pass to the detail screen
    // The detail screen will fetch full details using the ID
    final recipe = Recipe(
      id: meal.recipeId,
      title: meal.recipeTitle,
      calories: int.tryParse(meal.calories.split('.').first) ?? 0,
      cookingTimeMinutes: int.tryParse(meal.totalTime) ?? 0,
      ingredients: meal.ingredients.map((e) => e.phrase).toList(),
      instructions: [], // Will be fetched in detail screen
      region: meal.region,
      imageUrl: '', // Image URL is not provided in meal plan, detail screen logic handles fallback
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: const Text(
          'Weekly Meal Plan',
          style: TextStyle(
              color: Colors.black, fontFamily: 'DM Serif Display', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchMealPlan,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildMealPlanList(),
    );
  }

  Widget _buildMealPlanList() {
    if (_mealPlanResponse?.data?.mealPlan == null) {
      return const Center(child: Text('No meal plan data available.'));
    }

    final mealPlan = _mealPlanResponse!.data!.mealPlan;
    // Sort keys to ensure Day 1 comes before Day 2, etc.
    final sortedKeys = mealPlan.keys.toList()
      ..sort((a, b) {
        int dayA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        int dayB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return dayA.compareTo(dayB);
      });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final dayKey = sortedKeys[index];
        final dailyPlan = mealPlan[dayKey];
        return _buildDayCard(dayKey, dailyPlan);
      },
    );
  }

  Widget _buildDayCard(String day, DailyMealPlan? plan) {
    if (plan == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'DM Serif Display',
              ),
            ),
            const Divider(height: 24),
            _buildMealRow('Breakfast', plan.breakfast, Icons.wb_sunny_outlined),
            const SizedBox(height: 16),
            _buildMealRow('Lunch', plan.lunch, Icons.wb_sunny),
            const SizedBox(height: 16),
            _buildMealRow('Dinner', plan.dinner, Icons.nightlight_round),
          ],
        ),
      ),
    );
  }

  Widget _buildMealRow(String type, Meal? meal, IconData icon) {
    if (meal == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () => _navigateToRecipe(context, meal),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.orange, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.recipeTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department,
                          size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${meal.calories} kcal',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.timer, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${meal.totalTime} min',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
