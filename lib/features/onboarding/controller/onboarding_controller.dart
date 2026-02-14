class OnboardingController {
  // Singleton pattern
  static final OnboardingController _instance = OnboardingController._internal();
  factory OnboardingController() => _instance;
  OnboardingController._internal();

  // User Data
  int age = 24;
  double weight = 72.5; // kg
  double height = 175.0; // cm
  String gender = 'Male';
  List<String> healthConditions = [];
  String goal = 'Lose Weight';
  String dietType = 'Standard';

  // Methods to update data
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
}
