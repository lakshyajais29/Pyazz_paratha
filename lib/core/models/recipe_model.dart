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

  // Dummy Data
  static List<Recipe> get dummyRecipes => [
    Recipe(
      id: '1',
      title: 'Avocado Toast with Poached Egg',
      description: 'A classic breakfast choice packed with healthy fats and protein.',
      imageUrl: 'https://placehold.co/600x400/png?text=Avocado+Toast', // Placeholder
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
      imageUrl: 'https://placehold.co/600x400/png?text=Quinoa+Salad',
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
      imageUrl: 'https://placehold.co/600x400/png?text=Grilled+Salmon',
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
      imageUrl: 'https://placehold.co/600x400/png?text=Smoothie+Bowl',
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
