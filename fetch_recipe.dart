import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const url = 'http://cosylab.iiitd.edu.in/recipe2-api/recipe/recipeofday';
  const apiKey = 'f2VBYQzWdXlWQWvqWtu8Et1j5Hgw7UmrPahQowF9kulJW2q9';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {'x-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Pretty print JSON
      var encoder = JsonEncoder.withIndent("  ");
      final jsonString = encoder.convert(data);
      print(jsonString); // Keep console output just in case
      
      // Write to file for reliable reading
      final file = File('recipe_response.json');
      await file.writeAsString(jsonString);
      print('Written to recipe_response.json');
    } else {
      print('Failed to load recipe: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
