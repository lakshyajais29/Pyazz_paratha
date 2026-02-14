import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/models/recipe_model.dart';

class FavoritesController extends ChangeNotifier {
  static final FavoritesController _instance = FavoritesController._internal();
  factory FavoritesController() => _instance;
  FavoritesController._internal();

  final StorageService _storage = StorageService();
  
  // Store full recipes mapped by ID
  final Map<String, Recipe> _favorites = {};

  List<Recipe> get favoriteRecipes => _favorites.values.toList();
  List<String> get favoriteIds => _favorites.keys.toList();

  bool _isLoaded = false;

  Future<void> loadFavorites() async {
    if (_isLoaded) return;
    
    final storedJsonStrings = await _storage.getStringList(StorageService.keyFavorites);
    if (storedJsonStrings != null) {
      _favorites.clear();
      for (final jsonStr in storedJsonStrings) {
        try {
          final Map<String, dynamic> jsonMap = json.decode(jsonStr);
          // We need to cater for our fromApiJson expecting specific keys
          // Since we stored it using toJson, we might need a fromJson that matches toJson keys
          // OR we ensure toJson writes keys that fromApiJson can read.
          // Let's check Recipe.fromApiJson...
          // It looks for 'recipe_id' or 'id', 'title' etc. 
          // Our toJson writes 'recipe_id', 'title', 'img_url', etc.
          // Recipe.fromApiJson handles 'recipe_id', 'img_url' etc.
          // So it should work directly.
          final recipe = Recipe.fromApiJson(jsonMap);
          _favorites[recipe.id] = recipe;
        } catch (e) {
          debugPrint('Error parsing saved recipe: $e');
        }
      }
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    if (!_isLoaded) await loadFavorites();

    if (_favorites.containsKey(recipe.id)) {
      _favorites.remove(recipe.id);
    } else {
      _favorites[recipe.id] = recipe;
    }
    
    // Save as list of JSON strings
    final List<String> jsonList = _favorites.values.map((r) => json.encode(r.toJson())).toList();
    await _storage.saveStringList(StorageService.keyFavorites, jsonList);
    notifyListeners();
  }

  bool isFavorite(String recipeId) {
    return _favorites.containsKey(recipeId);
  }
}
