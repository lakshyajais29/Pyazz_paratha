import '../../../core/models/mood_model.dart';
import '../../../core/models/recipe_model.dart';
import '../../../core/services/recipedb_service.dart';

class MoodController {
  final RecipeDbService _recipeDbService = RecipeDbService();

  Mood? selectedMood;
  List<Recipe> moodRecipes = [];
  bool isLoading = false;

  /// Select a mood and fetch matching recipes
  Future<List<Recipe>> selectMood(Mood mood) async {
    selectedMood = mood;
    isLoading = true;
    try {
      // Use the mood's recipe category mapping to filter recipes by region
      moodRecipes = await _recipeDbService.getRecipesByRegion(
        mood.recipeCategory,
        limit: 15,
      );
      return moodRecipes;
    } catch (e) {
      return [];
    } finally {
      isLoading = false;
    }
  }

  /// Get all available moods
  List<Mood> getAllMoods() => Mood.allMoods;
}
