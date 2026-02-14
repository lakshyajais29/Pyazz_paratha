class OnboardingController {
  // Singleton pattern
  static final OnboardingController _instance = OnboardingController._internal();
  factory OnboardingController() => _instance;
  OnboardingController._internal();

  // User Data
  String name = '';
  int age = 24;
  double weight = 72.5; // kg
  double height = 175.0; // cm
  String gender = 'Male';
  List<String> healthConditions = [];
  String goal = 'Stay Balanced';
  String dietType = 'Standard';
  bool eatsEggs = true;
  bool eatsFish = false;
  bool jainFood = false;

  // Methods to update data
  void updateName(String newName) {
    name = newName;
  }

  void updateAge(int newAge) {
    age = newAge;
  }

  void updateWeight(double newWeight) {
    weight = newWeight;
  }

  void updateHeight(double newHeight) {
    height = newHeight;
  }

  void updateGender(String newGender) {
    gender = newGender;
  }

  void updateDietPreferences({bool? eggs, bool? fish, bool? jain}) {
    if (eggs != null) eatsEggs = eggs;
    if (fish != null) eatsFish = fish;
    if (jain != null) jainFood = jain;
  }

  /// Get exclude ingredients based on health conditions
  List<String> getExcludeIngredients() {
    List<String> excludes = [];
    if (healthConditions.contains('Diabetes')) {
      excludes.addAll(['sugar', 'honey', 'corn syrup']);
    }
    if (healthConditions.contains('Cholesterol')) {
      excludes.addAll(['butter', 'lard', 'cream']);
    }
    if (healthConditions.contains('Blood Pressure')) {
      excludes.addAll(['salt', 'soy sauce']);
    }
    if (jainFood) {
      excludes.addAll(['onion', 'garlic', 'potato']);
    }
    return excludes;
  }

  /// Get exclude categories based on diet type
  List<String> getExcludeCategories() {
    List<String> excludes = [];
    if (dietType == 'Vegetarian') {
      excludes.add('Meat');
      if (!eatsFish) excludes.add('Seafood');
      if (!eatsEggs) excludes.add('Eggs');
    }
    return excludes;
  }
}
