import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/recipe_model.dart';
import '../../../core/services/recipe_service.dart';
import '../../../core/services/recipedb_service.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  final String? moodFilter;
  const RecipeListScreen({super.key, this.moodFilter});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final RecipeService _recipeService = RecipeService();
  final RecipeDbService _recipeDbService = RecipeDbService();
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _recipes = [];
  List<Recipe> _allRecipes = []; // Full list for local filtering
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecipes() async {
    setState(() => _isLoading = true);
    List<Recipe> recipes;
    if (widget.moodFilter != null && widget.moodFilter!.isNotEmpty) {
      recipes = await _recipeDbService.getRecipesByRegion(widget.moodFilter!, limit: 20);
      if (recipes.isEmpty) {
        recipes = await _recipeService.getRecipes(page: 1, limit: 20);
      }
    } else {
      recipes = await _recipeService.getRecipes(page: 1, limit: 20);
    }
    if (mounted) {
      setState(() {
        _recipes = recipes;
        _allRecipes = recipes;
        _isLoading = false;
      });
    }
  }

  Future<void> _searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _recipes = _allRecipes;
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // Search by title using the working recipeByTitle API endpoint
    final apiResults = await _recipeDbService.searchRecipesByTitle(query.trim(), limit: 20);
    
    if (mounted) {
      setState(() { 
        _recipes = apiResults; 
        _isSearching = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Suggested Recipes', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'DM Serif Display', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: () {
              _searchController.clear();
              _fetchRecipes();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: _searchRecipes,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search recipes by ingredient...',
                  icon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _searchRecipes('');
                        },
                      )
                    : null,
                ),
                onChanged: (val) => setState(() {}), // Rebuild for clear icon
              ),
            ),
            const SizedBox(height: 20),
            
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Breakfast', true),
                  _buildFilterChip('Under 30 min', false),
                  _buildFilterChip('High Protein', false),
                  _buildFilterChip('Vegetarian', false),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recipe List
            Expanded(
              child: _isLoading || _isSearching
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _recipes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No recipes found',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[400]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term or ingredient',
                            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: SizedBox(
                              height: 180,
                              width: double.infinity,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                    recipe.imageUrl.startsWith('http')
                                      ? Image.network(
                                          recipe.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Icon(Icons.restaurant, size: 50, color: Colors.grey[400]),
                                            );
                                          },
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                          loadingProgress.expectedTotalBytes!
                                                      : null,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          recipe.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Icon(Icons.broken_image, size: 50, color: Colors.grey[400]),
                                            );
                                          },
                                        ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            recipe.rating.toString(),
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Details
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DM Serif Display',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_filled, color: Colors.grey[400], size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${recipe.cookingTimeMinutes} min',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(Icons.local_fire_department, color: Colors.grey[400], size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${recipe.calories} kcal',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? AppColors.primary : Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey[200]!),
      ),
    );
  }
}
