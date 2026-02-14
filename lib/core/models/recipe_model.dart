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
  final String region;
  final String subRegion;
  final String sourceUrl;

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
    this.region = '',
    this.subRegion = '',
    this.sourceUrl = '',
  });

  factory Recipe.fromApiJson(Map<String, dynamic> json) {
    // Helper to safely parse doubles/ints from String or Number
    double toDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int toInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      if (val is String) return double.tryParse(val)?.toInt() ?? 0;
      return 0;
    }
    
    // Extract calories — handle both upper/lowercase keys from different endpoints
    final calories = toInt(json['Calories'] ?? json['calories'] ?? json['energy (kcal)'] ?? json['Energy (kcal)']);
    final energyKcal = toDouble(json['Energy (kcal)'] ?? json['energy (kcal)'] ?? 0);
    final protein = toDouble(json['ProteinContent'] ?? json['protein (g)'] ?? json['Protein (g)']);
    final carbs = toDouble(json['CarbohydrateContent'] ?? json['carbohydrate, by difference (g)'] ?? json['Carbohydrate, by difference (g)']);
    final fat = toDouble(json['FatContent'] ?? json['total lipid (fat) (g)'] ?? json['Total lipid (fat) (g)']);

    // Extract image — both endpoints provide img_url
    String img = '';
    if (json['img_url'] != null) {
      final possibleImg = json['img_url'].toString();
      if (possibleImg.startsWith('http') && 
          !possibleImg.contains('gk-shareGraphic') &&
          !possibleImg.contains('gk/img/gk-share')) {
        img = possibleImg;
      }
    }
    
    // Use a placeholder image URL for recipes without proper food images
    if (img.isEmpty) {
      // Use a deterministic food placeholder based on recipe id
      final idVal = int.tryParse((json['Recipe_id'] ?? json['recipe_id'] ?? '0').toString()) ?? 0;
      final foodCategories = ['salad', 'pasta', 'soup', 'curry', 'steak', 'cake', 'rice', 'bread'];
      final category = foodCategories[idVal % foodCategories.length];
      img = 'https://img.sndimg.com/food/image/upload/w_555,h_416,c_fit,q_80/v1/img/recipes/no-image/$category.jpg';
    }

    // Region info (case-insensitive extraction)
    final region = (json['Region'] ?? json['region'] ?? '').toString();
    final subRegion = (json['Sub_region'] ?? json['sub_region'] ?? '').toString();

    // Parse Processes (the API provides cooking process verbs separated by ||)
    // Convert verb list into proper instruction steps
    List<String> instructions = [];
    final rawProcesses = json['Processes'] ?? json['processes'];
    if (rawProcesses != null && rawProcesses is String && rawProcesses.isNotEmpty) {
      final steps = rawProcesses.split('||').where((s) => s.trim().isNotEmpty).toList();
      // Capitalize and number the steps for better display
      for (int i = 0; i < steps.length; i++) {
        final step = steps[i].trim();
        final capitalized = step[0].toUpperCase() + step.substring(1);
        instructions.add(capitalized);
      }
    }
    // Fallback for other instruction formats
    if (instructions.isEmpty) {
      final rawInstructions = json['instructions'] ?? json['RecipeInstructions'];
      if (rawInstructions != null) {
        if (rawInstructions is List) {
          instructions = List<String>.from(rawInstructions);
        } else if (rawInstructions is String) {
          instructions = rawInstructions.split('.').where((s) => s.trim().isNotEmpty).map((s) => s.trim()).toList();
        }
      }
    }
    if (instructions.isEmpty) {
      instructions = ['Follow the recipe from the source link.'];
    }

    // Parse utensils (this is what the API provides as "equipment needed")
    List<String> utensils = [];
    final rawUtensils = json['utensils'] ?? json['Utensils'];
    if (rawUtensils != null && rawUtensils is String && rawUtensils.isNotEmpty) {
      utensils = rawUtensils.split('||').where((s) => s.trim().isNotEmpty).map((s) {
        final trimmed = s.trim();
        return trimmed[0].toUpperCase() + trimmed.substring(1);
      }).toList();
    }

    // Parse ingredients — check multiple possible formats from different endpoints
    List<String> ingredients = []; 
    if (json['ingredients'] != null && json['ingredients'] is List) {
      ingredients = (json['ingredients'] as List)
          .map((e) => e is Map ? (e['name'] ?? e.toString()).toString() : e.toString())
          .toList();
    } else if (json['RecipeIngredientParts'] != null) {
       ingredients = List<String>.from(json['RecipeIngredientParts']);
    } else if (json['ingredient_phrase'] != null) {
      // Smart recipe endpoint provides ingredient phrases
      final phrase = json['ingredient_phrase'].toString();
      if (phrase.isNotEmpty) {
        ingredients = [phrase];
      }
      // Also add the generic ingredient name if available
      if (json['ingredient'] != null) {
        final generic = json['ingredient'].toString();
        if (generic.isNotEmpty && !ingredients.any((i) => i.toLowerCase().contains(generic.toLowerCase()))) {
          ingredients.add(generic);
        }
      }
    }
    
    // If no ingredients, use utensils as "Equipment Needed"
    if (ingredients.isEmpty && utensils.isNotEmpty) {
      ingredients = utensils;
    }
    // Absolute fallback
    if (ingredients.isEmpty) {
      ingredients = ['See original recipe for full ingredients list'];
    }

    // Build description
    String description = '';
    if (region.isNotEmpty) {
      description = '$region${subRegion.isNotEmpty && subRegion != region ? ' • $subRegion' : ''} Cuisine';
    }
    if (description.isEmpty) {
      description = json['Description'] ?? json['description'] ?? 'A delicious recipe';
    }

    // Title (handle both upper/lowercase)
    final title = (json['Recipe_title'] ?? json['recipe_title'] ?? json['Name'] ?? json['name'] ?? 'Untitled Recipe').toString();
    // Clean title — remove excess quotes
    final cleanTitle = title.replaceAll(RegExp(r'^["\s]+|["\s]+$'), '');

    return Recipe(
      id: (json['Recipe_id'] ?? json['recipe_id'] ?? json['_id'] ?? '0').toString(),
      title: cleanTitle.isNotEmpty ? cleanTitle : 'Untitled Recipe',
      description: description,
      imageUrl: img,
      cookingTimeMinutes: toInt(json['total_time'] ?? json['TotalTime'] ?? json['cook_time']), 
      calories: energyKcal > 0 ? energyKcal.toInt() : calories,
      macros: {
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      },
      ingredients: ingredients,
      instructions: instructions,
      rating: 4.5,
      region: region,
      subRegion: subRegion,
      sourceUrl: (json['url'] ?? '').toString(),
    );
  }
}
