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
  // Recommendations
  List<RecipeRecommendation> recommendedMeals = [];
  bool isLoading = false;

  // --- Actions ---
  Future<void> fetchDailyRecipe() async {
    isLoading = true;
    recommendedMeals.clear();

    try {
      // 1. Fetch a batch of recipes
      final recipes = await _recipeService.getRecipes(limit: 20);
      
      // 2. Filter based on user preferences (client-side filter)
      final excludedIngredients = _onboarding.getExcludeIngredients();
      final excludedCategories = _onboarding.getExcludeCategories();

      // Calculate remaining calories for the day
      // Use a buffer (e.g., +50 or +100) to be a bit flexible, or strict.
      // Let's use strict remaining for now, but ensure we don't return 0 if they exceeded.
      // If remaining is low (e.g. < 0), we look for low calorie options (e.g. < 300).
      int limitCalories = caloriesRemaining;
      if (limitCalories < 100) {
        limitCalories = 300; // Recommendation shouldn't be empty, suggest a snack/light meal
      }

      final filtered = recipes.where((r) {
        // Filter by Ingredients
        for (var exclude in excludedIngredients) {
           if (r.ingredients.any((i) => i.toLowerCase().contains(exclude.toLowerCase()))) {
             return false;
           }
        }
        // Filter by Calories directly
        if (r.calories > limitCalories) {
          return false;
        }
        
        return true;
      }).toList();

      // 3. Select diverse options (2 distinct ones), prioritizing safe recipes
      List<Recipe> selection;
      
      if (filtered.isNotEmpty) {
        // Separate safe and warned recipes
        final safeRecipes = <Recipe>[];
        final warnedRecipes = <Recipe>[];
        
        for (var r in filtered) {
          if (_onboarding.getHealthWarningsForIngredients(r.ingredients).isEmpty) {
            safeRecipes.add(r);
          } else {
            warnedRecipes.add(r);
          }
        }

        // Shuffle for variety
        safeRecipes.shuffle();
        warnedRecipes.shuffle();
        
        // Combine: Safe first, then Warned
        final combined = [...safeRecipes, ...warnedRecipes];
        selection = combined.take(2).toList();
      } else {
        // Fallback
        recipes.sort((a, b) => a.calories.compareTo(b.calories));
        selection = recipes.take(2).toList();
      }
      
      // 4. Assign "Mood" tags & Warnings
      for (var recipe in selection) {
        String tag = 'Recommended For You 🎯';
        final warnings = _onboarding.getHealthWarningsForIngredients(recipe.ingredients);

        if (recipe.calories <= limitCalories) {
           tag = 'Fits Your Budget ✅';
        }

        if (recipe.cookingTimeMinutes <= 20) {
          tag = 'Quick & Easy ⚡';
        } else if (recipe.calories < 200) {
          tag = 'Low Calorie Snack 🍏';
        } else if ((recipe.macros['protein'] ?? 0) > 20) {
          tag = 'High Protein 💪';
        }
        
        if (recipe.calories > limitCalories && limitCalories == 300) {
           tag = 'Light Option 🥗';
        }

        recommendedMeals.add(RecipeRecommendation(
          recipe: recipe, 
          tag: tag,
          warnings: warnings, // Pass calculated warnings
        ));
      }

      // Ensure we have exactly 2 if possible, from fallback if completely empty
      if (recommendedMeals.isEmpty) {
        final fallback = await _recipeService.fetchRecipeOfTheDay();
        if (fallback != null) {
          recommendedMeals.add(RecipeRecommendation(recipe: fallback, tag: 'Recipe of the Day 🌟'));
        }
      }

    } catch (e) {
      // debugPrint('Error loading dashboard meals: $e');
    } finally {
      isLoading = false;
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

class RecipeRecommendation {
  final Recipe recipe;
  final String tag;
  final List<String> warnings;

  RecipeRecommendation({
    required this.recipe, 
    required this.tag,
    this.warnings = const [],
  });
}
