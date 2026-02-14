import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class RecipeService {
  static const String _baseUrl = 'http://cosylab.iiitd.edu.in/recipe2-api/recipe';
  static const String _apiKey = 'f2VBYQzWdXlWQWvqWtu8Et1j5Hgw7UmrPahQowF9kulJW2q9';

  // Fetch paginated recipes
  Future<List<Recipe>> getRecipes({int page = 1, int limit = 10}) async {
    final url = '$_baseUrl/recipesinfo?page=$page&limit=$limit';
    try {
      final response = await http.get(Uri.parse(url), headers: {'x-api-key': _apiKey});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Robust success check (API varies between "true" and true)
        final success = data['success'];
        final isSuccess = success == true || success.toString() == 'true';
        
        if (isSuccess && data['payload'] != null && data['payload']['data'] != null) {
           final List<dynamic> list = data['payload']['data'];
           return list.map((json) => Recipe.fromApiJson(json)).toList();
        }
      }
    } catch (e) {
      // debugPrint('Error fetching recipes list: $e');
    }
    return [];
  }

  // Fetch smart recipe (Recipe of Day with filters)
  // This seems to be a better version of "Recipe of the Day"
  Future<Recipe?> getSmartRecipe() async {
    // Hardcoded filters as per user example, can be parameterized later
    const url = '$_baseUrl/recipe-day/with-ingredients-categories?excludeIngredients=water,flour&excludeCategories=Dairy';
    try {
      final response = await http.get(Uri.parse(url), headers: {'x-api-key': _apiKey});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Robust check
        final success = data['success'];
        final isSuccess = success == true || success.toString() == 'true';

        if (isSuccess && data['payload'] != null) {
           // Direct payload has recipe data in this endpoint
           return Recipe.fromApiJson(data['payload']);
        }
      }
    } catch (e) {
      // debugPrint('Error fetching smart recipe: $e');
    }
    return null;
  }

  Future<Recipe?> fetchRecipeOfTheDay() async {
    // Keeping this as a fallback or simpler version
    // ... logic remains ...
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/recipeofday'),
        headers: {'x-api-key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final success = data['success'];
        final isSuccess = success == true || success.toString() == 'true';

        if (isSuccess && data['payload'] != null && data['payload']['data'] != null) {
          return Recipe.fromApiJson(data['payload']['data']);
        }
      } 
    } catch (e) {
       // ...
    }
    return null;
  }

  // Fetch detailed recipe by title
  Future<Recipe?> getRecipeByTitle(String title) async {
    try {
      final encodedTitle = Uri.encodeComponent(title);
      final url = 'http://cosylab.iiitd.edu.in/recipe2-api/recipe-bytitle/recipeByTitle?title=$encodedTitle';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'x-api-key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final success = data['success'];
        final isSuccess = success == true || success.toString() == 'true';

        if (isSuccess && data['data'] != null && data['data'] is List && (data['data'] as List).isNotEmpty) {
          // The API returns an array, take the first match
          return Recipe.fromApiJson(data['data'][0]);
        }
      }
    } catch (e) {
      // debugPrint('Error fetching recipe by title: $e');
    }
    return null;
  }
}
