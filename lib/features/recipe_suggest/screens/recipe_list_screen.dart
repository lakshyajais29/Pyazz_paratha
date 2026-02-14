import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/recipe_model.dart';
import '../../../core/services/recipe_service.dart';
import '../../../core/services/recipedb_service.dart';
import 'recipe_detail_screen.dart';
import '../../onboarding/controller/onboarding_controller.dart';

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
  String? _selectedFilter; // Currently selected filter (null = none)

  // Filter definitions
  final List<String> _filters = ['Breakfast', 'Under 30 min', 'High Protein', 'Vegetarian'];

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
      recipes = await _recipeDbService.getRecipesByRegion(widget.moodFilter!, limit: 50);
      if (recipes.isEmpty) {
        recipes = await _recipeService.getRecipes(page: 1, limit: 50);
      }
    } else {
      recipes = await _recipeService.getRecipes(page: 1, limit: 50);
    }
    if (mounted) {
      setState(() {
        _allRecipes = recipes;
        _isLoading = false;
        _applyFilter(); // Apply current filter after fetching
      });
    }
  }

  /// Apply the selected filter on _allRecipes and update _recipes
  void _applyFilter() {
    if (_selectedFilter == null) {
      _recipes = List.from(_allRecipes);
      return;
    }

    switch (_selectedFilter) {
      case 'Breakfast':
        _recipes = _allRecipes.where((r) {
          final titleLower = r.title.toLowerCase();
          final descLower = r.description.toLowerCase();
          return titleLower.contains('breakfast') ||
              titleLower.contains('pancake') ||
              titleLower.contains('oatmeal') ||
              titleLower.contains('egg') ||
              titleLower.contains('toast') ||
              titleLower.contains('cereal') ||
              titleLower.contains('smoothie') ||
              titleLower.contains('muffin') ||
              titleLower.contains('waffle') ||
              titleLower.contains('omelette') ||
              titleLower.contains('omelet') ||
              descLower.contains('breakfast');
        }).toList();
        break;
      case 'Under 30 min':
        _recipes = _allRecipes.where((r) {
          return r.cookingTimeMinutes > 0 && r.cookingTimeMinutes <= 30;
        }).toList();
        break;
      case 'High Protein':
        _recipes = _allRecipes.where((r) {
          final protein = r.macros['protein'] ?? 0;
          return protein >= 15; // 15g+ protein considered high
        }).toList();
        break;
      case 'Vegetarian':
        _recipes = _allRecipes.where((r) {
          final titleLower = r.title.toLowerCase();
          final ingredientsLower = r.ingredients.join(' ').toLowerCase();
          // Exclude recipes with obvious non-veg keywords
          final nonVegKeywords = ['chicken', 'beef', 'pork', 'lamb', 'fish', 'shrimp',
            'salmon', 'tuna', 'bacon', 'sausage', 'steak', 'turkey', 'meat', 'prawn',
            'crab', 'lobster', 'ham', 'duck', 'venison', 'anchov'];
          return !nonVegKeywords.any((k) =>
              titleLower.contains(k) || ingredientsLower.contains(k));
        }).toList();
        break;
      default:
        _recipes = List.from(_allRecipes);
    }
    
    // Sort by health warnings: Safe first, Warned last
    final controller = OnboardingController();
    _recipes.sort((a, b) {
      final aWarn = controller.getHealthWarningsForIngredients(a.ingredients).isNotEmpty;
      final bWarn = controller.getHealthWarningsForIngredients(b.ingredients).isNotEmpty;
      if (aWarn && !bWarn) return 1;
      if (!aWarn && bWarn) return -1;
      return 0;
    });
  }

  void _onFilterTap(String filter) {
    setState(() {
      // If same filter tapped again, deselect it (show all)
      if (_selectedFilter == filter) {
        _selectedFilter = null;
      } else {
        _selectedFilter = filter;
      }
      _applyFilter();
    });
  }

  Future<void> _searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _selectedFilter = null; // Reset filter on empty search
        _applyFilter();
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // Search by title using the working recipeByTitle API endpoint
    final apiResults = await _recipeDbService.searchRecipesByTitle(query.trim(), limit: 20);
    
    if (mounted) {
      setState(() { 
        _allRecipes = apiResults;
        _selectedFilter = null; // Reset filter on new search
        _applyFilter();
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
              _selectedFilter = null;
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
            
            // Filter Chips — single selection
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) => 
                  _buildFilterChip(filter, _selectedFilter == filter)
                ).toList(),
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
                            _selectedFilter != null 
                              ? 'No "$_selectedFilter" recipes found'
                              : 'No recipes found',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[400]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedFilter != null
                              ? 'Try removing the filter or refresh for more recipes'
                              : 'Try a different search term or ingredient',
                            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                          ),
                          if (_selectedFilter != null) ...[
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => _onFilterTap(_selectedFilter!),
                              child: const Text('Clear Filter', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                    )
                  : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                final warnings = OnboardingController().getHealthWarningsForIngredients(recipe.ingredients);

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
                        border: warnings.isNotEmpty 
                            ? Border.all(color: Colors.red.withOpacity(0.5), width: 1)
                            : null,
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
                                  if (warnings.isNotEmpty)
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.red[100]!),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Health Alert',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red),
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
                                if (warnings.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      warnings.first,
                                      style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
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
    return GestureDetector(
      onTap: () => _onFilterTap(label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ] : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}