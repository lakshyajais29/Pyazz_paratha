import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/recipe_model.dart';
import '../../../core/services/recipe_service.dart';
import '../../../core/services/gemini_service.dart';
import '../../cooking_assistant/screens/cooking_screen.dart'; // Navigate to Cooking

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeService _recipeService = RecipeService();
  final GeminiService _geminiService = GeminiService(); // Mistral AI Service
  Recipe? _detailedRecipe;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isGeneratingAI = false;

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
      
      Recipe? finalRecipe = detailedRecipe ?? widget.recipe;
      
      // Check if instructions are missing or just a placeholder.
      bool hasValidInstructions = finalRecipe.instructions.isNotEmpty && 
          !(finalRecipe.instructions.length == 1 && 
            finalRecipe.instructions.first.contains('Follow the recipe'));

      if (!hasValidInstructions) {
        if (mounted) setState(() => _isGeneratingAI = true);
        
        try {
          debugPrint('Instructions missing or placeholder. Generating with AI for: ${finalRecipe.title}');
          final aiInstructions = await _geminiService.generateRecipeInstructions(finalRecipe.title);
          
          if (aiInstructions != null && aiInstructions.isNotEmpty) {
            // Create a new recipe object with AI instructions
            finalRecipe = Recipe(
              id: finalRecipe!.id,
              title: finalRecipe.title,
              description: finalRecipe.description,
              imageUrl: finalRecipe.imageUrl,
              cookingTimeMinutes: finalRecipe.cookingTimeMinutes,
              calories: finalRecipe.calories,
              ingredients: finalRecipe.ingredients,
              instructions: aiInstructions,
              macros: finalRecipe.macros,
              rating: finalRecipe.rating,
              region: finalRecipe.region,
              subRegion: finalRecipe.subRegion,
              sourceUrl: finalRecipe.sourceUrl,
            );
          }
        } catch (e) {
          debugPrint('AI Generation failed: $e');
        } finally {
          if (mounted) setState(() => _isGeneratingAI = false);
        }
      }

      if (mounted) {
        setState(() {
          _detailedRecipe = finalRecipe;
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

  Future<void> _generateAIRecipe() async {
    final currentRecipe = _detailedRecipe ?? widget.recipe;
    
    setState(() => _isGeneratingAI = true);
    
    try {
      debugPrint('Manual AI Generation for: ${currentRecipe.title}');
      final aiInstructions = await _geminiService.generateRecipeInstructions(currentRecipe.title);
      
      if (aiInstructions != null && aiInstructions.isNotEmpty) {
        if (mounted) {
           setState(() {
             // Create a new recipe object with AI instructions
             _detailedRecipe = Recipe(
               id: currentRecipe.id,
               title: currentRecipe.title,
               description: currentRecipe.description,
               imageUrl: currentRecipe.imageUrl,
               cookingTimeMinutes: currentRecipe.cookingTimeMinutes,
               calories: currentRecipe.calories,
               ingredients: currentRecipe.ingredients,
               instructions: aiInstructions,
               macros: currentRecipe.macros,
               rating: currentRecipe.rating,
               region: currentRecipe.region,
               subRegion: currentRecipe.subRegion,
               sourceUrl: currentRecipe.sourceUrl,
             );
             _isGeneratingAI = false;
           });
           
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
               content: Text('✨ Recipe instructions generated successfully!'),
               backgroundColor: AppColors.primary,
             ),
           );
        }
      } else {
        throw Exception('No instructions generated');
      }
    } catch (e) {
      debugPrint('AI Generation failed: $e');
      if (mounted) {
        setState(() => _isGeneratingAI = false);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to generate recipe: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the detailed recipe if available, otherwise use the passed recipe
    final recipe = _detailedRecipe ?? widget.recipe;
    // Instructions are now handled in _fetchRecipeDetails (either API, AI, or fallback)
    // But we keep this check just in case
    final instructions = recipe.instructions.isNotEmpty 
        ? recipe.instructions 
        : widget.recipe.instructions;

    return Scaffold(
      backgroundColor: Colors.white,
      body: (_isLoading || _isGeneratingAI)
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 6.0),
                                      child: Icon(Icons.circle, size: 8, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(ingredient, style: const TextStyle(fontSize: 15, height: 1.4))),
                                  ],
                                ),
                              )
                            ).toList(),
                          ),
                        ),

                         const SizedBox(height: 30),

                          // Region & Cuisine Info
                         if (recipe.region.isNotEmpty)
                           Container(
                             padding: const EdgeInsets.all(16),
                             margin: const EdgeInsets.only(bottom: 24),
                             decoration: BoxDecoration(
                               color: Colors.orange[50],
                               borderRadius: BorderRadius.circular(16),
                               border: Border.all(color: Colors.orange[100]!),
                             ),
                             child: Row(
                               children: [
                                 const Icon(Icons.public, color: AppColors.primary, size: 20),
                                 const SizedBox(width: 12),
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       const Text('Cuisine', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                                       Text(
                                         '${recipe.region}${recipe.subRegion.isNotEmpty && recipe.subRegion != recipe.region ? ' • ${recipe.subRegion}' : ''}',
                                         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ),

                         // AI Generation Button
                         Container(
                           width: double.infinity,
                           margin: const EdgeInsets.only(bottom: 24),
                           child: ElevatedButton.icon(
                             onPressed: _generateAIRecipe,
                             
                             label: const Text('Show Recipe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                             style: ElevatedButton.styleFrom(
                               backgroundColor: AppColors.primary,
                               padding: const EdgeInsets.symmetric(vertical: 12),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                             ),
                           ),
                         ),

                         // Cooking Steps
                         const Text(
                           'Cooking Steps',
                           style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                             fontFamily: 'DM Serif Display',
                           ),
                         ),
                         const SizedBox(height: 16),
                         ...instructions.asMap().entries.map((entry) {
                           final idx = entry.key + 1;
                           final step = entry.value;
                           return Container(
                             margin: const EdgeInsets.only(bottom: 12),
                             padding: const EdgeInsets.all(16),
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(12),
                               border: Border.all(color: Colors.grey[200]!),
                             ),
                             child: Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Container(
                                   width: 32,
                                   height: 32,
                                   decoration: BoxDecoration(
                                     color: AppColors.primary,
                                     borderRadius: BorderRadius.circular(8),
                                   ),
                                   child: Center(
                                     child: Text(
                                       '$idx',
                                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                     ),
                                   ),
                                 ),
                                 const SizedBox(width: 12),
                                 Expanded(
                                   child: Padding(
                                     padding: const EdgeInsets.only(top: 5.0),
                                     child: Text(
                                       step,
                                       style: const TextStyle(fontSize: 15, height: 1.4, color: AppColors.textSecondary),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           );
                         }),

                         const SizedBox(height: 16),

                         // Source Link
                         if (recipe.sourceUrl.isNotEmpty)
                           Container(
                             padding: const EdgeInsets.all(12),
                             margin: const EdgeInsets.only(bottom: 16),
                             decoration: BoxDecoration(
                               color: Colors.blue[50],
                               borderRadius: BorderRadius.circular(12),
                             ),
                             child: Row(
                               children: [
                                 Icon(Icons.link, color: Colors.blue[700], size: 20),
                                 const SizedBox(width: 8),
                                 const Expanded(
                                   child: Text(
                                     'View full recipe with detailed instructions on the source website',
                                     style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                                   ),
                                 ),
                               ],
                             ),
                           ),

                         const SizedBox(height: 8),

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
            _isGeneratingAI 
                ? 'Creating step-by-step instructions with AI...' 
                : 'Loading recipe details...',
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
