import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyName = 'user_name';
  static const String keyAge = 'user_age';
  static const String keyWeight = 'user_weight';
  static const String keyHeight = 'user_height';
  static const String keyGender = 'user_gender';
  static const String keyGoal = 'user_goal';
  static const String keyDietType = 'user_diet_type';
  static const String keyEatsEggs = 'user_eats_eggs';
  static const String keyEatsFish = 'user_eats_fish';
  static const String keyJainFood = 'user_jain_food';
  static const String keyHealthConditions = 'user_health_conditions';

  // Check if onboarding is complete
  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyOnboardingComplete) ?? false;
  }
  
  // Generic Getters
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Generic Setters
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<void> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Clear all data (Sign Out)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
