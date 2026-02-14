import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_strings.dart';
import '../models/recipe_model.dart';

/// Extended RecipeDB service for additional search endpoints
class RecipeDbService {
  static const String _baseUrl = AppStrings.recipeApiBaseUrl;
  static const String _apiKey = AppStrings.foodoscopeApiKey;

  Map<String, String> get _headers => {'x-api-key': _apiKey};

  /// Search recipes by title keyword (main search endpoint)
  Future<List<Recipe>> searchRecipesByTitle(String query, {int page = 1, int limit = 10}) async {
    try {
      final encoded = Uri.encodeComponent(query);
      // Use the recipe-bytitle endpoint which supports partial title matching
      final url = 'http://cosylab.iiitd.edu.in/recipe2-api/recipe-bytitle/recipeByTitle?title=$encoded&page=$page&limit=$limit';
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final success = data['success'];
        final isSuccess = success == true || success.toString() == 'true';
        if (isSuccess && data['data'] != null && data['data'] is List) {
          final List<dynamic> list = data['data'];
          return list.map((json) => Recipe.fromApiJson(json)).toList();
        }
      }
    } catch (e) {
      // debugPrint('RecipeDB search error: $e');
    }
    return [];
  }

  /// Search recipes by region/cuisine
  Future<List<Recipe>> getRecipesByRegion(String region, {int page = 1, int limit = 10}) async {
    try {
      final url = '$_baseUrl/region/$region?page=$page&limit=$limit';
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        return _parseRecipeListResponse(response.body);
      }
    } catch (e) {
      // debugPrint('RecipeDB region error: $e');
    }
    return [];
  }

  /// Search recipes by sub-region
  Future<List<Recipe>> getRecipesBySubRegion(String subRegion, {int page = 1, int limit = 10}) async {
    try {
      final url = '$_baseUrl/sub-region/$subRegion?page=$page&limit=$limit';
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        return _parseRecipeListResponse(response.body);
      }
    } catch (e) {
      // debugPrint('RecipeDB sub-region error: $e');
    }
    return [];
  }

  /// Get recipe by ID
  Future<Recipe?> getRecipeById(String id) async {
    try {
      final url = '$_baseUrl/$id';
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final success = data['success'];
        final isSuccess = success == true || success.toString() == 'true';
        if (isSuccess && data['payload'] != null) {
          return Recipe.fromApiJson(data['payload']);
        }
      }
    } catch (e) {
      // debugPrint('RecipeDB id error: $e');
    }
    return null;
  }

  /// Get recipes by ingredient (uses title search as fallback since ingredient endpoint is unavailable)
  Future<List<Recipe>> getRecipesByIngredient(String ingredient, {int page = 1, int limit = 10}) async {
    // The ingredient-specific endpoint is not available, use title search instead
    return searchRecipesByTitle(ingredient, page: page, limit: limit);
  }

  /// Get recipes with exclusions (for health conditions)
  Future<Recipe?> getRecipeWithExclusions({
    List<String> excludeIngredients = const [],
    List<String> excludeCategories = const [],
  }) async {
    try {
      final excludeIng = excludeIngredients.join(',');
      final excludeCat = excludeCategories.join(',');
      final url = '$_baseUrl/recipe-day/with-ingredients-categories?excludeIngredients=$excludeIng&excludeCategories=$excludeCat';
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final success = data['success'];
        final isSuccess = success == true || success.toString() == 'true';
        if (isSuccess && data['payload'] != null) {
          final payload = data['payload'];
          if (payload['data'] != null) {
            final payloadData = payload['data'];
            if (payloadData is List && payloadData.isNotEmpty) {
              return Recipe.fromApiJson(payloadData[0]);
            } else if (payloadData is Map<String, dynamic>) {
              return Recipe.fromApiJson(payloadData);
            }
          }
        }
      }
    } catch (e) {
      // debugPrint('RecipeDB exclusion error: $e');
    }
    return null;
  }

  /// Helper to parse standard paginated recipe responses
  List<Recipe> _parseRecipeListResponse(String body) {
    try {
      final data = json.decode(body);
      final success = data['success'];
      final isSuccess = success == true || success.toString() == 'true';

      if (isSuccess) {
        // Try payload → data (standard format)
        if (data['payload'] != null && data['payload']['data'] != null) {
          final List<dynamic> list = data['payload']['data'];
          return list.map((json) => Recipe.fromApiJson(json)).toList();
        }
        // Try data directly
        if (data['data'] != null && data['data'] is List) {
          final List<dynamic> list = data['data'];
          return list.map((json) => Recipe.fromApiJson(json)).toList();
        }
      }
    } catch (e) {
      // debugPrint('Parse error: $e');
    }
    return [];
  }
}
