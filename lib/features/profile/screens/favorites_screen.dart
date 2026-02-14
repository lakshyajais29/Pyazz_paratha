import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/recipe_model.dart';
import '../../../core/services/recipedb_service.dart';
import '../../recipe_suggest/screens/recipe_detail_screen.dart';
import '../controller/favorites_controller.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesController _favoritesController = FavoritesController();
  final RecipeDbService _recipeDbService = RecipeDbService();
  
  List<Recipe> _favoriteRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    await _favoritesController.loadFavorites();
    
    if (mounted) {
      setState(() {
        _favoriteRecipes = _favoritesController.favoriteRecipes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Recipes', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'DM Serif Display', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _favoriteRecipes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No saved recipes yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the heart icon on recipes you love!',
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favoriteRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _favoriteRecipes[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                        // Refresh list when returning, in case user unsaved it
                        _loadFavorites();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                             ClipRRect(
                               borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                               child: recipe.imageUrl.startsWith('http')
                                 ? Image.network(
                                     recipe.imageUrl,
                                     width: 100,
                                     height: 100,
                                     fit: BoxFit.cover,
                                     errorBuilder: (c, o, s) => Container(width: 100, height: 100, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                                   )
                                 : Image.asset(
                                     recipe.imageUrl,
                                     width: 100,
                                     height: 100,
                                     fit: BoxFit.cover,
                                     errorBuilder: (c, o, s) => Container(width: 100, height: 100, color: Colors.grey[200]),
                                   ),
                             ),
                             Expanded(
                               child: Padding(
                                 padding: const EdgeInsets.all(12.0),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       recipe.title,
                                       maxLines: 2,
                                       overflow: TextOverflow.ellipsis,
                                       style: const TextStyle(
                                         fontWeight: FontWeight.bold,
                                         fontSize: 16,
                                         color: AppColors.textPrimary,
                                       ),
                                     ),
                                     const SizedBox(height: 4),
                                     Text(
                                       '${recipe.calories} kcal • ${recipe.cookingTimeMinutes} min',
                                       style: TextStyle(
                                         color: Colors.grey[500],
                                         fontSize: 12,
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                             IconButton(
                               icon: const Icon(Icons.favorite, color: AppColors.primary),
                               onPressed: () async {
                                 await _favoritesController.toggleFavorite(recipe);
                                 _loadFavorites(); // Refresh list
                               },
                             ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
