import 'dart:convert';

import 'package:yummy/models/recipe.dart';

List<Recipe> parseRecipes(String responseText) {
  List<Recipe> recipes = [];

  try {
    // regex to find JSON objects in a text
    final matches = RegExp(r'\{.*?\}', dotAll: true).allMatches(responseText);

    for (var match in matches) {
      final jsonStr = match.group(0);
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr);
        if (decoded is Map<String, dynamic>) {
          recipes.add(Recipe.fromJson(decoded));
        }
      }
    }
  } catch (e) {
    print('Failed to parse recipes: $e');
  }

  return recipes;
}
