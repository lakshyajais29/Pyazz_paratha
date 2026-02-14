import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/app_strings.dart';
import '../models/nutrition_model.dart';

/// Mistral AI Vision service for food image analysis
/// Uses Pixtral model via Chat Completions API
class GeminiService {
  /// Analyze a food photo and return nutritional information
  /// Tries multiple providers in sequence: Mistral Primary -> Mistral Secondary -> Fal AI
  Future<NutritionInfo?> analyzeFoodImage(String base64Image) async {
    final providers = [
      _ProviderConfig(
        name: 'Mistral AI (Primary)',
        url: AppStrings.mistralApiUrl,
        apiKey: AppStrings.mistralApiKeyPrimary,
        model: 'pixtral-12b-2409',
      ),
      _ProviderConfig(
        name: 'Mistral AI (Secondary)',
        url: AppStrings.mistralApiUrl,
        apiKey: AppStrings.mistralApiKeySecondary,
        model: 'pixtral-12b-2409',
      ),
      _ProviderConfig(
        name: 'Fal AI (Pixtral)',
        url: 'https://queue.fal.run/fal-ai/pixtral-12b/v1/chat/completions', // OpenAI-compatible endpoint
        apiKey: AppStrings.falAiApiKey, 
        model: 'pixtral-12b', // Model name might be ignored by Fal but good to have
        isFal: true,
      ),
    ];

    for (final provider in providers) {
      debugPrint('Attempting analysis with ${provider.name}...');
      try {
        final result = await _analyzeWithProvider(provider, base64Image);
        if (result != null) {
          debugPrint('Success with ${provider.name}');
          return result;
        }
      } catch (e) {
        debugPrint('Failed with ${provider.name}: $e');
      }
      debugPrint('Switching to next provider...');
    }
    
    debugPrint('All providers failed.');
    throw Exception('All AI providers failed. Check internet or API keys.');
  }

  Future<NutritionInfo?> _analyzeWithProvider(_ProviderConfig provider, String base64Image) async {
    // Fal AI requires a different key format usually (Key id:secret), but strictly speaking
    // their OpenAI compatible endpoint uses "Authorization: Key <key_id:key_secret>"
    // or standard Bearer. Fal docs say "Authorization: Key ..."
    final authHeader = provider.isFal 
        ? 'Key ${provider.apiKey}' 
        : 'Bearer ${provider.apiKey}';

    try {
      final response = await http.post(
        Uri.parse(provider.url),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': provider.model,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': '''Identify the food in this image.
Respond ONLY with this JSON structure:
{
  "food_name": "Food Name",
  "calories": 100,
  "protein": 10,
  "carbs": 10,
  "fat": 10,
  "fiber": 0,
  "sugar": 0,
  "serving_size": "1 serving"
}
If unsure, estimate.'''
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
          'max_tokens': 300,
          'temperature': 0.1,
        }),
      ).timeout(const Duration(seconds: 30)); // Add timeout

      debugPrint('${provider.name} Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices']?[0]?['message']?['content'];
        debugPrint('${provider.name} Content: $content'); // LOG THE CONTENT
        if (content != null) {
          final nutritionJson = _extractJson(content);
          if (nutritionJson != null) {
            return NutritionInfo.fromMistralResponse(nutritionJson);
          }
        }
      } else {
        debugPrint('${provider.name} Error Body: ${response.body}');
      }
    } catch (e) {
       debugPrint('Error with ${provider.name}: $e');
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

class _ProviderConfig {
  final String name;
  final String url;
  final String apiKey;
  final String model;
  final bool isFal;

  _ProviderConfig({
    required this.name,
    required this.url,
    required this.apiKey,
    required this.model,
    this.isFal = false,
  });
}
