import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/recipe_model.dart';
import '../../../core/services/recipe_service.dart';
import '../../cooking_assistant/screens/cooking_screen.dart'; // Navigate to Cooking

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeService _recipeService = RecipeService();
  Recipe? _fullRecipe;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFullRecipeDetails();
  }

  Future<void> _fetchFullRecipeDetails() async {
    setState(() => _isLoading = true);
    
    // Try to fetch full recipe details by ID
    final fullRecipe = await _recipeService.getRecipeById(widget.recipe.id);
    
    if (mounted) {
      setState(() {
        // Use fetched recipe if available, otherwise use the passed recipe
        _fullRecipe = fullRecipe ?? widget.recipe;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the full recipe if loaded, otherwise use the initial recipe
    final recipe = _fullRecipe ?? widget.recipe;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
        slivers: [
          // Collapsible App Bar with Image
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: AppColors.primary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
               IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, color: AppColors.primary),
                ),
                onPressed: () {},
              ),
               const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey[300], 
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    recipe.imageUrl.startsWith('http') 
                      ? Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              Icon(Icons.broken_image, size: 100, color: Colors.grey[400]),
                        )
                      : Image.asset(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 50, color: Colors.grey)),
                        ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DM Serif Display',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.rating} (120 reviews)',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Nutrition Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNutritionItem(Icons.local_fire_department, '${recipe.calories} kcal', 'Calories'),
                      _buildNutritionItem(Icons.timer, '${recipe.cookingTimeMinutes} min', 'Time'),
                      _buildNutritionItem(Icons.restaurant, '${recipe.ingredients.length} items', 'Ingredients'),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Ingredients List
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DM Serif Display',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: recipe.ingredients.map((ingredient) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.circle, size: 8, color: AppColors.primary),
                              const SizedBox(width: 12),
                              Text(ingredient, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        )
                      ).toList(),
                    ),
                  ),

                   const SizedBox(height: 30),

                   // Instructions Preview (Just first one)
                   const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DM Serif Display',
                    ),
                  ),
                   const SizedBox(height: 16),
                   Text(
                     recipe.instructions.join('\n\n'),
                     style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.textSecondary),
                   ),

                   const SizedBox(height: 40),

                   // Start Cooking Button
                   ElevatedButton(
                     onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CookingScreen(recipe: recipe),
                          ),
                        );
                     },
                     style: ElevatedButton.styleFrom(
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                     ),
                     child: const Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.play_arrow),
                         SizedBox(width: 8),
                         Text('Start Cooking Assistant'),
                       ],
                     ),
                   ),
                   const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
