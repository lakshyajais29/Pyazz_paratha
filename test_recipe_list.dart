import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Copy of Recipe model logic for testing
class Recipe {
  final String id;
  final String title;

  Recipe({required this.id, required this.title});

  factory Recipe.fromApiJson(Map<String, dynamic> json) {
    try {
      final title = json['Recipe_title'] ?? json['recipe_title'] ?? json['Name'] ?? 'Unknown Title';
      print('Parsed Recipe: "$title"');
      return Recipe(
        id: (json['Recipe_id'] ?? json['recipe_id'] ?? json['_id'] ?? '0').toString(),
        title: title,
      );
    } catch (e) {
      print('Error parsing recipe: $e');
      rethrow;
    }
  }
}

Future<void> main() async {
  const url = 'http://cosylab.iiitd.edu.in/recipe2-api/recipe/recipesinfo?page=1&limit=5';
  const apiKey = 'f2VBYQzWdXlWQWvqWtu8Et1j5Hgw7UmrPahQowF9kulJW2q9';

  try {
    print('Fetching from: $url');
    final response = await http.get(Uri.parse(url), headers: {'x-api-key': apiKey});
    
    print('Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Success field: ${data['success']} (Type: ${data['success'].runtimeType})');
      
      // Robust check
      bool isSuccess = data['success'] == true || data['success'] == 'true';
      if (isSuccess) {
         if (data['payload'] != null && data['payload']['data'] != null) {
           final List<dynamic> list = data['payload']['data'];
           print('--- Found ${list.length} items ---');
           for (var item in list) {
             Recipe.fromApiJson(item);
           }
           print('--- Parse Completed Successfully ---');
         } else {
           print('Payload or data is null');
           print('Payload keys: ${data['payload']?.keys}');
         }
      } else {
        print('API returned success=false');
      }
    } else {
      print('HTTP Error: ${response.body}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
