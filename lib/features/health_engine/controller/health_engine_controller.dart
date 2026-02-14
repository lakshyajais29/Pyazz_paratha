import '../../../core/models/nutrition_model.dart';
import '../../../shared/utils/bmr_calculator.dart';
import '../../onboarding/controller/onboarding_controller.dart';

class HealthEngineController {
  static final HealthEngineController _instance = HealthEngineController._internal();
  factory HealthEngineController() => _instance;
  HealthEngineController._internal();

  final OnboardingController _onboarding = OnboardingController();
  final List<LoggedMeal> _loggedMeals = [];

  /// Calculate BMR from user's onboarding data
  double get bmr => BmrCalculator.calculateBMR(
    weightKg: _onboarding.weight,
    heightCm: _onboarding.height,
    age: _onboarding.age,
    gender: _onboarding.gender,
  );

  /// Calculate BMI
  double get bmi => BmrCalculator.calculateBMI(
    weightKg: _onboarding.weight,
    heightCm: _onboarding.height,
  );

  /// BMI category string
  String get bmiCategory => BmrCalculator.bmiCategory(bmi);

  /// Daily calorie target based on goal
  double get dailyCalorieTarget => BmrCalculator.dailyCalorieTarget(
    bmr: bmr,
    goal: _onboarding.goal,
  );

  /// Recommended macros
  Map<String, double> get recommendedMacros => BmrCalculator.recommendedMacros(
    dailyCalories: dailyCalorieTarget,
    goal: _onboarding.goal,
  );

  /// Log a meal
  void logMeal(NutritionInfo nutrition, {String? imageBase64}) {
    _loggedMeals.add(LoggedMeal(
      nutrition: nutrition,
      timestamp: DateTime.now(),
      imageBase64: imageBase64,
    ));
  }

  /// Get today's logged meals
  List<LoggedMeal> get todaysMeals {
    final today = DateTime.now();
    return _loggedMeals.where((meal) =>
      meal.timestamp.year == today.year &&
      meal.timestamp.month == today.month &&
      meal.timestamp.day == today.day
    ).toList();
  }

  /// Today's total calories consumed
  int get todayCalories => todaysMeals.fold(0, (sum, meal) => sum + meal.nutrition.calories);

  /// Today's total protein
  double get todayProtein => todaysMeals.fold(0.0, (sum, meal) => sum + meal.nutrition.protein);

  /// Today's total carbs
  double get todayCarbs => todaysMeals.fold(0.0, (sum, meal) => sum + meal.nutrition.carbs);

  /// Today's total fat
  double get todayFat => todaysMeals.fold(0.0, (sum, meal) => sum + meal.nutrition.fat);

  /// Number of meals logged today
  int get mealsLoggedToday => todaysMeals.length;

  /// All logged meals history
  List<LoggedMeal> get allMeals => _loggedMeals;
}
