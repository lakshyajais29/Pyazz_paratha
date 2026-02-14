class BmrCalculator {
  /// Mifflin-St Jeor Equation for BMR
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
  }) {
    if (gender.toLowerCase() == 'male') {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
  }

  /// BMI = weight(kg) / height(m)^2
  static double calculateBMI({
    required double weightKg,
    required double heightCm,
  }) {
    final heightM = heightCm / 100;
    if (heightM <= 0) return 0;
    return weightKg / (heightM * heightM);
  }

  /// Daily calorie target based on goal
  static double dailyCalorieTarget({
    required double bmr,
    required String goal,
  }) {
    // Using sedentary multiplier (1.2) as base
    final tdee = bmr * 1.2;
    switch (goal.toLowerCase()) {
      case 'burn fat':
      case 'lose weight':
        return tdee - 500; // 500 cal deficit
      case 'build muscle':
      case 'strength':
        return tdee + 300; // 300 cal surplus
      case 'stay balanced':
      case 'maintenance':
      default:
        return tdee;
    }
  }

  /// Recommended macros in grams based on calorie target and goal
  static Map<String, double> recommendedMacros({
    required double dailyCalories,
    required String goal,
  }) {
    double proteinRatio, carbsRatio, fatRatio;

    switch (goal.toLowerCase()) {
      case 'burn fat':
      case 'lose weight':
        proteinRatio = 0.35;
        carbsRatio = 0.35;
        fatRatio = 0.30;
        break;
      case 'build muscle':
      case 'strength':
        proteinRatio = 0.30;
        carbsRatio = 0.45;
        fatRatio = 0.25;
        break;
      default:
        proteinRatio = 0.25;
        carbsRatio = 0.50;
        fatRatio = 0.25;
    }

    return {
      'protein': (dailyCalories * proteinRatio) / 4, // 4 cal per gram protein
      'carbs': (dailyCalories * carbsRatio) / 4, // 4 cal per gram carbs
      'fat': (dailyCalories * fatRatio) / 9, // 9 cal per gram fat
    };
  }

  /// BMI Category
  static String bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
}
