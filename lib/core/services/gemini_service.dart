import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_strings.dart';
import '../models/nutrition_model.dart';

/// Mistral AI Vision service for food image analysis
/// Uses Pixtral model via Chat Completions API
class GeminiService {
  static const String _apiUrl = AppStrings.mistralApiUrl;
  static const String _apiKey = AppStrings.mistralApiKey;

  /// Analyze a food photo and return nutritional information
  /// [base64Image] - Base64 encoded image string
  Future<NutritionInfo?> analyzeFoodImage(String base64Image) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'pixtral-12b-2409',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': '''Analyze this food image. Identify the food item(s) and provide nutritional information.
Respond ONLY with a valid JSON object (no markdown, no code blocks) with these exact keys:
{
  "food_name": "name of the food",
  "calories": estimated calories as integer,
  "protein": protein in grams as number,
  "carbs": carbohydrates in grams as number,
  "fat": fat in grams as number,
  "fiber": fiber in grams as number,
  "sugar": sugar in grams as number,
  "serving_size": "estimated serving size"
}'''
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image'
                  }
                }
              ]
            }
          ],
          'max_tokens': 500,
          'temperature': 0.1,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices']?[0]?['message']?['content'];
        if (content != null) {
          // Parse JSON from the response
          final nutritionJson = _extractJson(content);
          if (nutritionJson != null) {
            return NutritionInfo.fromMistralResponse(nutritionJson);
          }
        }
      }
    } catch (e) {
      // debugPrint('Mistral AI error: $e');
    }
    return null;
  }

  /// Extract JSON from possible markdown-wrapped response
  Map<String, dynamic>? _extractJson(String content) {
    try {
      // Try direct parse first
      return json.decode(content);
    } catch (_) {
      // Try to extract from markdown code blocks
      final codeBlockRegex = RegExp(r'```(?:json)?\s*\n?(.*?)\n?```', dotAll: true);
      final match = codeBlockRegex.firstMatch(content);
      if (match != null) {
        try {
          return json.decode(match.group(1)!);
        } catch (_) {}
      }
      // Try to find JSON object in the string
      final jsonRegex = RegExp(r'\{[^{}]*\}', dotAll: true);
      final jsonMatch = jsonRegex.firstMatch(content);
      if (jsonMatch != null) {
        try {
          return json.decode(jsonMatch.group(0)!);
        } catch (_) {}
      }
    }
    return null;
  }
}
