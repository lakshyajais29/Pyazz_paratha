class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int cookingTimeMinutes;
  final int calories;
  final Map<String, double> macros; // Protein, Carbs, Fat
  final List<String> ingredients;
  final List<String> instructions;
  final double rating;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cookingTimeMinutes,
    required this.calories,
    required this.ingredients,
    required this.instructions,
    this.macros = const {'protein': 0, 'carbs': 0, 'fat': 0},
    this.rating = 4.5,
  });

  factory Recipe.fromApiJson(Map<String, dynamic> json) {
    // Helper to safely parse doubles/ints from String or Number
    double toDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) {
        // Remove non-numeric chars if needed, but usually just parsing works
        return double.tryParse(val) ?? 0.0;
      }
      return 0.0;
    }

    int toInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      if (val is String) {
        return double.tryParse(val)?.toInt() ?? 0;
      }
      return 0;
    }
    
    // Extract macros using multiple possible keys (API inconsistency handling)
    final calories = toInt(json['Calories'] ?? json['energy (kcal)'] ?? json['Energy (kcal)']);
    final protein = toDouble(json['ProteinContent'] ?? json['protein (g)'] ?? json['Protein (g)']);
    final carbs = toDouble(json['CarbohydrateContent'] ?? json['carbohydrate, by difference (g)'] ?? json['Carbohydrate, by difference (g)']);
    final fat = toDouble(json['FatContent'] ?? json['total lipid (fat) (g)'] ?? json['Total lipid (fat) (g)']);

    // Extract image
    String img = '';
    if (json['img_url'] != null) {
      final possibleImg = json['img_url'] as String;
      if (possibleImg.startsWith('http')) {
        img = possibleImg;
      }
    }
    
    // Fallback if no image (common in new API)
    if (img.isEmpty) {
      final idVal = int.tryParse((json['Recipe_id'] ?? json['recipe_id'] ?? '0').toString()) ?? 0;
      final stockImages = [
        'assets/images/food/salmon.jpg',
        'assets/images/food/avoctoast.jpg',
        'assets/images/food/berry.jpg',
        'assets/images/food/quinoa.jpg',
      ];
      img = stockImages[idVal % stockImages.length];
    }

    // Parse ingredients
    // Endpoint 1 (recipesinfo): No standard ingredients list, has "Utensils"?
    // Endpoint 2 (smart): "ingredients": [{"name": "onion"}, ...]
    List<String> ingredients = []; 
    if (json['ingredients'] != null && json['ingredients'] is List) {
      ingredients = (json['ingredients'] as List)
          .map((e) => e['name'].toString())
          .toList();
    } else if (json['RecipeIngredientParts'] != null) {
       ingredients = List<String>.from(json['RecipeIngredientParts']);
    }

    // Parse instructions
    List<String> instructions = [];
    final rawProcesses = json['Processes'] ?? json['processes'];
    final rawInstructions = json['instructions'] ?? json['RecipeInstructions'];

    if (rawProcesses != null && rawProcesses is String) {
      // Pipe separated logic
      instructions = rawProcesses.split('||');
    } else if (rawInstructions != null) {
      if (rawInstructions is List) {
        instructions = List<String>.from(rawInstructions);
      } else if (rawInstructions is String) {
        // Sentence based? Split by period?
        instructions = rawInstructions.split('.').where((s) => s.trim().isNotEmpty).toList();
      }
    }

    return Recipe(
      id: (json['Recipe_id'] ?? json['recipe_id'] ?? json['_id'] ?? '0').toString(),
      title: json['Recipe_title'] ?? json['recipe_title'] ?? json['Name'] ?? 'Delicious Recipe',
      description: json['Region'] != null ? '${json['Region']} - ${json['Sub_region']} Cuisine' : 'A delicious meal for you.',
      imageUrl: img,
      cookingTimeMinutes: toInt(json['total_time'] ?? json['TotalTime'] ?? json['cook_time']), 
      calories: calories,
      macros: {
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      },
      ingredients: ingredients.isNotEmpty ? ingredients : ['Fresh Ingredients'],
      instructions: instructions.isNotEmpty ? instructions : ['Prepare ingredients.', 'Cook with love.', 'Enjoy!'], 
      rating: 4.5, // Default rating as API doesn't seem to have it
    );
  }

  // Dummy Data
  static List<Recipe> get dummyRecipes => [
    Recipe(
      id: '1',
      title: 'Avocado Toast with Poached Egg',
      description: 'A classic breakfast choice packed with healthy fats and protein.',
      imageUrl: 'assets/images/food/avoctoast.jpg',
      cookingTimeMinutes: 15,
      calories: 350,
      macros: {'protein': 12, 'carbs': 30, 'fat': 18},
      ingredients: [
        '2 slices Whole Wheat Bread',
        '1 Ripe Avocado',
        '2 Large Eggs',
        '1 tsp Chili Flakes',
        'Salt & Pepper to taste'
      ],
      instructions: [
        'Toast the bread slices until golden brown.',
        'Mash the avocado with salt and pepper.',
        'Poach the eggs in simmering water for 3-4 minutes.',
        'Spread avocado on toast and top with egg.',
        'Sprinkle chili flakes and serve.'
      ],
    ),
    Recipe(
      id: '2',
      title: 'Quinoa & Black Bean Salad',
      description: 'Refreshing salad rich in fiber and antioxidants.',
      imageUrl: 'assets/images/food/quinoa.jpg',
      cookingTimeMinutes: 20,
      calories: 420,
      macros: {'protein': 15, 'carbs': 55, 'fat': 10},
      ingredients: [
        '1 cup Quinoa (cooked)',
        '1/2 cup Black Beans',
        '1 Red Bell Pepper (diced)',
        '1/4 cup Corn',
        'Lemon Vinaigrette'
      ],
      instructions: [
        'Combine quinoa, beans, peppers, and corn in a large bowl.',
        'Drizzle with vinaigrette and toss effectively.',
        'Garnish with cilantro if desired.',
        'Serve chilled or at room temperature.'
      ],
      rating: 4.8,
    ),
    Recipe(
      id: '3',
      title: 'Grilled Salmon with Asparagus',
      description: 'Omega-3 rich dinner ready in under 30 minutes.',
      imageUrl: 'assets/images/food/salmon.jpg',
      cookingTimeMinutes: 25,
      calories: 500,
      macros: {'protein': 40, 'carbs': 5, 'fat': 25},
      ingredients: [
        '1 Salmon Fillet',
        '1 bunch Asparagus',
        '2 tbsp Olive Oil',
        '1 Lemon (sliced)',
        'Garlic Powder'
      ],
      instructions: [
        'Preheat oven to 400°F (200°C).',
        'Place salmon and asparagus on a baking sheet.',
        'Drizzle with oil and season generously.',
        'Bake for 12-15 minutes until salmon flakes easily.',
        'Serve with lemon wedges.'
      ],
      rating: 4.9,
    ),
     Recipe(
      id: '4',
      title: 'Berry Smoothie Bowl',
      description: 'Sweet and tangy start to your day.',
      imageUrl: 'assets/images/food/berry.jpg',
      cookingTimeMinutes: 5,
      calories: 280,
      macros: {'protein': 8, 'carbs': 45, 'fat': 6},
      ingredients: [
        '1 cup Mixed Frozen Berries',
        '1 Banana',
        '1/2 cup Almond Milk',
        '1 tbsp Chia Seeds',
        'Granola for topping'
      ],
      instructions: [
        'Blend berries, banana, and milk until smooth.',
        'Pour into a bowl.',
        'Top with chia seeds and granola.',
        'Enjoy immediately.'
      ],
      rating: 4.7,
    ),
  ];
}
