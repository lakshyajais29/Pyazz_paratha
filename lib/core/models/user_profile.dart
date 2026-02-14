class UserProfile {
  final String name;
  final int age;
  final double weight; // kg
  final double height; // cm
  final String gender;
  final String goal;
  final String dietType;
  final List<String> healthConditions;
  final bool eatsEggs;
  final bool eatsFish;
  final bool jainFood;

  UserProfile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.goal,
    required this.dietType,
    this.healthConditions = const [],
    this.eatsEggs = true,
    this.eatsFish = false,
    this.jainFood = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'weight': weight,
    'height': height,
    'gender': gender,
    'goal': goal,
    'dietType': dietType,
    'healthConditions': healthConditions,
    'eatsEggs': eatsEggs,
    'eatsFish': eatsFish,
    'jainFood': jainFood,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] ?? '',
    age: json['age'] ?? 24,
    weight: (json['weight'] ?? 70.0).toDouble(),
    height: (json['height'] ?? 170.0).toDouble(),
    gender: json['gender'] ?? 'Male',
    goal: json['goal'] ?? 'Stay Balanced',
    dietType: json['dietType'] ?? 'Standard',
    healthConditions: List<String>.from(json['healthConditions'] ?? []),
    eatsEggs: json['eatsEggs'] ?? true,
    eatsFish: json['eatsFish'] ?? false,
    jainFood: json['jainFood'] ?? false,
  );
}
