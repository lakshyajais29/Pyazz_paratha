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
  Recipe? _detailedRecipe;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRecipeDetails();
  }

  Future<void> _fetchRecipeDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final detailedRecipe = await _recipeService.getRecipeByTitle(widget.recipe.title);
      
      if (mounted) {
        setState(() {
          _detailedRecipe = detailedRecipe ?? widget.recipe; // Fallback to original recipe
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _detailedRecipe = widget.recipe; // Fallback to original recipe
          _isLoading = false;
          _errorMessage = 'Could not load full recipe details';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the detailed recipe if available, otherwise use the passed recipe
    final recipe = _detailedRecipe ?? widget.recipe;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? _buildLoadingState()
          : CustomScrollView(
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
                        // Error message if any
                        if (_errorMessage != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(color: Colors.orange[700], fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),

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
                                    Expanded(child: Text(ingredient, style: const TextStyle(fontSize: 16))),
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
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading recipe details...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
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
