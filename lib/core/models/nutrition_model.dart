class NutritionInfo {
  final String foodName;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final String servingSize;

  NutritionInfo({
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0,
    this.sugar = 0,
    this.servingSize = '1 serving',
  });

  factory NutritionInfo.fromMistralResponse(Map<String, dynamic> json) {
    return NutritionInfo(
      foodName: json['food_name'] ?? 'Unknown Food',
      calories: (json['calories'] ?? 0).toInt(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      fiber: (json['fiber'] ?? 0).toDouble(),
      sugar: (json['sugar'] ?? 0).toDouble(),
      servingSize: json['serving_size'] ?? '1 serving',
    );
  }

  Map<String, dynamic> toJson() => {
    'food_name': foodName,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'fiber': fiber,
    'sugar': sugar,
    'serving_size': servingSize,
  };
}

/// Represents a logged meal with nutrition + timestamp
class LoggedMeal {
  final NutritionInfo nutrition;
  final DateTime timestamp;
  final String? imageBase64;

  LoggedMeal({
    required this.nutrition,
    required this.timestamp,
    this.imageBase64,
  });
}
