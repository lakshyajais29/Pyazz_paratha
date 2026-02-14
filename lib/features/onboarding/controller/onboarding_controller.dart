import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';

class OnboardingController {
  // Singleton pattern
  static final OnboardingController _instance = OnboardingController._internal();
  factory OnboardingController() => _instance;
  OnboardingController._internal();

  final StorageService _storage = StorageService();

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

  /// Load data from storage on app start
  Future<void> loadUserData() async {
    name = await _storage.getString(StorageService.keyName) ?? '';
    age = await _storage.getInt(StorageService.keyAge) ?? 24;
    weight = await _storage.getDouble(StorageService.keyWeight) ?? 72.5;
    height = await _storage.getDouble(StorageService.keyHeight) ?? 175.0;
    gender = await _storage.getString(StorageService.keyGender) ?? 'Male';
    goal = await _storage.getString(StorageService.keyGoal) ?? 'Stay Balanced';
    dietType = await _storage.getString(StorageService.keyDietType) ?? 'Standard';
    eatsEggs = await _storage.getBool(StorageService.keyEatsEggs) ?? true;
    eatsFish = await _storage.getBool(StorageService.keyEatsFish) ?? false;
    jainFood = await _storage.getBool(StorageService.keyJainFood) ?? false;
    
    final conditionsString = await _storage.getString(StorageService.keyHealthConditions);
    if (conditionsString != null && conditionsString.isNotEmpty) {
      healthConditions = conditionsString.split(',');
    }
  }

  /// Save current data to storage
  Future<void> saveUserData() async {
    await _storage.saveString(StorageService.keyName, name);
    await _storage.saveInt(StorageService.keyAge, age);
    await _storage.saveDouble(StorageService.keyWeight, weight);
    await _storage.saveDouble(StorageService.keyHeight, height);
    await _storage.saveString(StorageService.keyGender, gender);
    await _storage.saveString(StorageService.keyGoal, goal);
    await _storage.saveString(StorageService.keyDietType, dietType);
    await _storage.saveBool(StorageService.keyEatsEggs, eatsEggs);
    await _storage.saveBool(StorageService.keyEatsFish, eatsFish);
    await _storage.saveBool(StorageService.keyJainFood, jainFood);
    await _storage.saveString(StorageService.keyHealthConditions, healthConditions.join(','));
    await _storage.saveBool(StorageService.keyOnboardingComplete, true);
  }

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

  // Update existing methods to save data? 
  // For better performance, we might want to call saveUserData() only at the end of onboarding
  // or when leaving a screen, rather than on every keystroke.
  // The current implementation assumes saveUserData() is called explicitly, e.g. on "Next/Finish" button.
  
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
    } else if (dietType == 'Vegan') {
       excludes.addAll(['Meat', 'Seafood', 'Eggs', 'Dairy']);
    }
    return excludes;
  }
  /// Sign Out: Clear all data and navigate to welcome
  Future<void> signOut(context) async {
    // 1. Clear Storage
    await _storage.clearAllData();
    
    // 2. Reset In-Memory Data (Singleton)
    _resetData();

    // 3. Navigate to Welcome Screen explicitly
    // Using '/welcome' because '/' might still point to Dashboard if app started as logged-in
    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
  }

  void _resetData() {
    name = '';
    age = 24;
    weight = 72.5;
    height = 175.0;
    gender = 'Male';
    healthConditions = [];
    goal = 'Stay Balanced';
    dietType = 'Standard';
    eatsEggs = true;
    eatsFish = false;
    jainFood = false;
  }
}
