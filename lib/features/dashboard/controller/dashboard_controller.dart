import '../../../core/services/recipe_service.dart';
import '../../../core/models/recipe_model.dart';
import '../../../core/models/nutrition_model.dart';
import '../../onboarding/controller/onboarding_controller.dart';
import '../../../shared/utils/bmr_calculator.dart';

class DashboardController {
  // Singleton
  static final DashboardController _instance = DashboardController._internal();
  factory DashboardController() => _instance;
  DashboardController._internal();

  final RecipeService _recipeService = RecipeService();
  final OnboardingController _onboarding = OnboardingController();

  // Logged meals for the day
  final List<LoggedMeal> _loggedMeals = [];

  // --- User Info (from onboarding, no more hardcoded) ---
  String get userName => _onboarding.name.isNotEmpty ? _onboarding.name : 'User';
  String get userGoal => _onboarding.goal;

  // --- Calorie / Macro Goals (calculated from user data) ---
  double get bmr => BmrCalculator.calculateBMR(
    weightKg: _onboarding.weight,
    heightCm: _onboarding.height,
    age: _onboarding.age,
    gender: _onboarding.gender,
  );

  double get calorieGoal => BmrCalculator.dailyCalorieTarget(bmr: bmr, goal: _onboarding.goal);

  Map<String, double> get macroGoals => BmrCalculator.recommendedMacros(
    dailyCalories: calorieGoal,
    goal: _onboarding.goal,
  );

  // --- Today's Consumed (from logged meals, dynamic) ---
  int get caloriesConsumed => _loggedMeals.fold(0, (sum, m) => sum + m.nutrition.calories);
  double get proteinCurrent => _loggedMeals.fold(0.0, (sum, m) => sum + m.nutrition.protein);
  double get carbsCurrent => _loggedMeals.fold(0.0, (sum, m) => sum + m.nutrition.carbs);
  double get fatCurrent => _loggedMeals.fold(0.0, (sum, m) => sum + m.nutrition.fat);

  // --- Goals (from calculated) ---
  double get proteinGoal => macroGoals['protein'] ?? 100;
  double get carbsGoal => macroGoals['carbs'] ?? 200;
  double get fatGoal => macroGoals['fat'] ?? 60;

  // --- Screen compatibility getters ---
  int get caloriesRemaining => (calorieGoal - caloriesConsumed).clamp(0, calorieGoal.toInt()).toInt();
  double get calorieProgress => calorieGoal > 0 ? (caloriesConsumed / calorieGoal).clamp(0.0, 1.0) : 0.0;

  // Water tracking (user manually tracks)
  double waterConsumed = 0; // liters
  double get waterGoal => _onboarding.weight * 0.033; // 33ml per kg

  // Meals logged count
  int get mealsLogged => _loggedMeals.length;

  // Next Meal (from API) — non-nullable with fallback
  Recipe nextMeal = Recipe(
    id: '0',
    title: 'Loading...',
    description: 'Fetching your recommendation',
    imageUrl: 'assets/images/food/salmon.jpg',
    cookingTimeMinutes: 0,
    calories: 0,
    ingredients: [],
    instructions: [],
  );

  // --- Actions ---
  Future<void> fetchDailyRecipe() async {
    final recipe = await _recipeService.getSmartRecipe();
    if (recipe != null) {
      nextMeal = recipe;
      return;
    }
    // Fallback to recipe of the day
    final fallback = await _recipeService.fetchRecipeOfTheDay();
    if (fallback != null) {
      nextMeal = fallback;
    }
  }

  /// Alias for backward compat
  Future<void> fetchNextMeal() async => fetchDailyRecipe();

  void logMeal(NutritionInfo nutrition) {
    _loggedMeals.add(LoggedMeal(
      nutrition: nutrition,
      timestamp: DateTime.now(),
    ));
  }

  void addWater(double liters) {
    waterConsumed += liters;
  }

  List<LoggedMeal> get todaysMeals => _loggedMeals;
}
