import '../../../core/services/recipe_service.dart';
import '../../../core/services/recipedb_service.dart';
import '../../../core/models/recipe_model.dart';

class RecipeController {
  final RecipeService _recipeService = RecipeService();
  final RecipeDbService _recipeDbService = RecipeDbService();

  List<Recipe> recipes = [];
  bool isLoading = false;
  String? errorMessage;
  int _currentPage = 1;

  /// Fetch recipes with pagination
  Future<List<Recipe>> fetchRecipes({int page = 1, int limit = 10}) async {
    isLoading = true;
    errorMessage = null;
    try {
      final result = await _recipeService.getRecipes(page: page, limit: limit);
      if (page == 1) {
        recipes = result;
      } else {
        recipes.addAll(result);
      }
      _currentPage = page;
      return result;
    } catch (e) {
      errorMessage = 'Failed to load recipes';
      return [];
    } finally {
      isLoading = false;
    }
  }

  /// Load next page
  Future<List<Recipe>> loadMore() async {
    return fetchRecipes(page: _currentPage + 1);
  }

  /// Search recipes by title
  Future<Recipe?> searchByTitle(String title) async {
    isLoading = true;
    try {
      return await _recipeService.getRecipeByTitle(title);
    } finally {
      isLoading = false;
    }
  }

  /// Get recipes by region/cuisine (for mood-based filtering)
  Future<List<Recipe>> fetchByRegion(String region) async {
    isLoading = true;
    try {
      final result = await _recipeDbService.getRecipesByRegion(region);
      recipes = result;
      return result;
    } finally {
      isLoading = false;
    }
  }

  /// Get recipes by ingredient
  Future<List<Recipe>> fetchByIngredient(String ingredient) async {
    isLoading = true;
    try {
      final result = await _recipeDbService.getRecipesByIngredient(ingredient);
      recipes = result;
      return result;
    } finally {
      isLoading = false;
    }
  }

  /// Get recipe of the day
  Future<Recipe?> getRecipeOfDay() async {
    return await _recipeService.getSmartRecipe();
  }

  /// Get recipe with health-based exclusions
  Future<Recipe?> getHealthyRecipe({
    List<String> excludeIngredients = const [],
    List<String> excludeCategories = const [],
  }) async {
    return await _recipeDbService.getRecipeWithExclusions(
      excludeIngredients: excludeIngredients,
      excludeCategories: excludeCategories,
    );
  }
}
