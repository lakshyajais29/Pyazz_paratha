import '../../../core/services/flavordb_service.dart';

class SubstitutionController {
  final FlavorDbService _flavorDbService = FlavorDbService();

  List<FlavorCompound> results = [];
  bool isLoading = false;
  String? errorMessage;

  /// Search for flavor substitutes by taste
  Future<List<FlavorCompound>> searchByTaste(String taste) async {
    isLoading = true;
    errorMessage = null;
    try {
      results = await _flavorDbService.getByTasteThreshold(taste);
      if (results.isEmpty) {
        errorMessage = 'No compounds found for "$taste"';
      }
      return results;
    } catch (e) {
      errorMessage = 'Failed to search: $e';
      return [];
    } finally {
      isLoading = false;
    }
  }

  /// Search by aroma
  Future<List<FlavorCompound>> searchByAroma(String aroma) async {
    isLoading = true;
    errorMessage = null;
    try {
      results = await _flavorDbService.getByAromaThreshold(aroma);
      if (results.isEmpty) {
        errorMessage = 'No compounds found for "$aroma"';
      }
      return results;
    } catch (e) {
      errorMessage = 'Failed to search: $e';
      return [];
    } finally {
      isLoading = false;
    }
  }
}
