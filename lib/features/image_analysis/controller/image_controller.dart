import 'dart:convert';
import 'dart:io';
import '../../../core/services/gemini_service.dart';
import '../../../core/models/nutrition_model.dart';

class ImageController {
  final GeminiService _geminiService = GeminiService();

  NutritionInfo? analysisResult;
  bool isAnalyzing = false;
  String? errorMessage;

  /// Analyze a food image from file path
  Future<NutritionInfo?> analyzeImage(String imagePath) async {
    isAnalyzing = true;
    errorMessage = null;
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        errorMessage = 'Image file not found';
        return null;
      }

      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      analysisResult = await _geminiService.analyzeFoodImage(base64Image);
      if (analysisResult == null) {
        errorMessage = 'Could not analyze the image. Try again.';
      }

      return analysisResult;
    } catch (e) {
      errorMessage = 'Analysis failed: $e';
      return null;
    } finally {
      isAnalyzing = false;
    }
  }

  /// Clear previous result
  void clearResult() {
    analysisResult = null;
    errorMessage = null;
  }
}
