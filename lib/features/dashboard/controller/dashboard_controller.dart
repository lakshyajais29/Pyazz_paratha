import '../../../core/models/recipe_model.dart';

class DashboardController {
  // Singleton pattern
  static final DashboardController _instance = DashboardController._internal();
  factory DashboardController() => _instance;
  DashboardController._internal();

  // Mock Data
  final int dailyCalorieGoal = 2200;
  int caloriesConsumed = 750;
  
  // Macros (Current / Goal)
  final double proteinCurrent = 45;
  final double proteinGoal = 140;
  
  final double carbsCurrent = 90;
  final double carbsGoal = 250;
  
  final double fatCurrent = 30;
  final double fatGoal = 70;

  // Hydration
  double waterIntakeLiters = 1.2;
  final double waterGoalLiters = 3.0;

  // Next Meal Suggestion
  Recipe nextMeal = Recipe(
    id: 'suggested_1',
    title: 'Grilled Salmon Bowl',
    description: 'A perfect balance of protein and healthy fats for your lunch.',
    imageUrl: 'assets/images/food/salmon_bowl.png', // Local asset or network
    cookingTimeMinutes: 25,
    calories: 450,
    macros: {'protein': 35, 'carbs': 40, 'fat': 18},
    ingredients: ['Salmon Fillet', 'Brown Rice', 'Avocado', 'Cucumber', 'Sesame Seeds'],
    instructions: ['Grill the salmon.', 'Cook the rice.', 'Assemble the bowl.', 'Top with sesame seeds.'],
    rating: 4.8,
  );

  double get calorieProgress => caloriesConsumed / dailyCalorieGoal;
  int get caloriesRemaining => dailyCalorieGoal - caloriesConsumed;

  void logMeal(int calories, int protein, int carbs, int fat) {
    caloriesConsumed += calories;
    // Simulate macro updates
    // proteinCurrent += protein; 
    // carbsCurrent += carbs;
    // fatCurrent += fat;
    
    // Notify listeners if using Provider/GetX, here relying on setState in Dashboard
  }
}
