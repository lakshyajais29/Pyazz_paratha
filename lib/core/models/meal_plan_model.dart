
class MealPlanResponse {
  final String message;
  final MealPlanData? data;

  MealPlanResponse({
    required this.message,
    this.data,
  });

  factory MealPlanResponse.fromJson(Map<String, dynamic> json) {
    return MealPlanResponse(
      message: json['message'] ?? '',
      data: json['data'] != null ? MealPlanData.fromJson(json['data']) : null,
    );
  }
}

class MealPlanData {
  final String dietType;
  final int days;
  final List<String> excludeIngredients;
  final Map<String, DailyMealPlan> mealPlan;

  MealPlanData({
    required this.dietType,
    required this.days,
    required this.excludeIngredients,
    required this.mealPlan,
  });

  factory MealPlanData.fromJson(Map<String, dynamic> json) {
    var mealPlanMap = <String, DailyMealPlan>{};
    if (json['meal_plan'] != null) {
      json['meal_plan'].forEach((key, value) {
        mealPlanMap[key] = DailyMealPlan.fromJson(value);
      });
    }

    return MealPlanData(
      dietType: json['diet_type'] ?? '',
      days: json['days'] ?? 0,
      excludeIngredients: json['exclude_ingredients'] != null
          ? List<String>.from(json['exclude_ingredients'])
          : [],
      mealPlan: mealPlanMap,
    );
  }
}

class DailyMealPlan {
  final Meal? breakfast;
  final Meal? lunch;
  final Meal? dinner;

  DailyMealPlan({
    this.breakfast,
    this.lunch,
    this.dinner,
  });

  factory DailyMealPlan.fromJson(Map<String, dynamic> json) {
    return DailyMealPlan(
      breakfast:
          json['Breakfast'] != null ? Meal.fromJson(json['Breakfast']) : null,
      lunch: json['Lunch'] != null ? Meal.fromJson(json['Lunch']) : null,
      dinner: json['Dinner'] != null ? Meal.fromJson(json['Dinner']) : null,
    );
  }
}

class Meal {
  final String recipeId;
  final String recipeTitle;
  final String calories;
  final String totalTime;
  final String region;
  final List<MealIngredient> ingredients;

  Meal({
    required this.recipeId,
    required this.recipeTitle,
    required this.calories,
    required this.totalTime,
    required this.region,
    required this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    var ingredientsList = <MealIngredient>[];
    if (json['ingredients'] != null) {
      json['ingredients'].forEach((v) {
        ingredientsList.add(MealIngredient.fromJson(v));
      });
    }
    return Meal(
      recipeId: json['Recipe_id']?.toString() ?? '',
      recipeTitle: json['Recipe_title'] ?? '',
      calories: json['Calories']?.toString() ?? '',
      totalTime: json['total_time']?.toString() ?? '',
      region: json['Region'] ?? '',
      ingredients: ingredientsList,
    );
  }
}

class MealIngredient {
  final String ingredient;
  final String? quantity;
  final String? unit;
  final String? state;
  final String phrase;

  MealIngredient({
    required this.ingredient,
    this.quantity,
    this.unit,
    this.state,
    required this.phrase,
  });

  factory MealIngredient.fromJson(Map<String, dynamic> json) {
    return MealIngredient(
      ingredient: json['ingredient'] ?? '',
      quantity: json['quantity']?.toString(),
      unit: json['unit'],
      state: json['state'],
      phrase: json['phrase'] ?? '',
    );
  }
}
