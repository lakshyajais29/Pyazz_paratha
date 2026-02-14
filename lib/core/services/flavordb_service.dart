import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_strings.dart';

class FlavorDbService {
  static const String _baseUrl = AppStrings.flavorDbBaseUrl;
  static const String _apiKey = AppStrings.foodoscopeApiKey;

  /// Search flavor compounds by taste threshold
  /// e.g., taste = "fruity", "sweet", "bitter", "spicy"
  Future<List<FlavorCompound>> getByTasteThreshold(String taste) async {
    try {
      final url = '$_baseUrl/properties/taste-threshold?values=${Uri.encodeComponent(taste)}';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['content'] != null && data['content'] is List) {
          return (data['content'] as List)
              .map((item) => FlavorCompound.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      // debugPrint('FlavorDB error: $e');
    }
    return [];
  }

  /// Search by aroma threshold
  Future<List<FlavorCompound>> getByAromaThreshold(String aroma) async {
    try {
      final url = '$_baseUrl/properties/aroma-threshold?values=${Uri.encodeComponent(aroma)}';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['content'] != null && data['content'] is List) {
          return (data['content'] as List)
              .map((item) => FlavorCompound.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      // debugPrint('FlavorDB aroma error: $e');
    }
    return [];
  }
}

class FlavorCompound {
  final String id;
  final String name;
  final String? synonyms;
  final String? tasteDescription;
  final String? aromaDescription;
  final String? naturalOccurrence;
  final String? empiricalFormula;

  FlavorCompound({
    required this.id,
    required this.name,
    this.synonyms,
    this.tasteDescription,
    this.aromaDescription,
    this.naturalOccurrence,
    this.empiricalFormula,
  });

  factory FlavorCompound.fromJson(Map<String, dynamic> json) {
    return FlavorCompound(
      id: json['_id'] ?? '',
      name: json['Name'] ?? 'Unknown',
      synonyms: json['Synonyms'],
      tasteDescription: json['Taste_threshold_values'],
      aromaDescription: json['Aroma_threshold_values'],
      naturalOccurrence: json['Natural_occurrence'],
      empiricalFormula: json['Empirical_Formula_MW'],
    );
  }
}
