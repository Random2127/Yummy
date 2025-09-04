import 'package:flutter/material.dart';
import 'package:yummy/models/recipe.dart';
import 'package:yummy/widgets/recipe_card.dart';

class RecipeBubble extends StatelessWidget {
  final Recipe recipe;
  const RecipeBubble({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // match chat bubble color
        borderRadius: BorderRadius.circular(16),
      ),
      child: RecipeCard(recipe: recipe),
    );
  }
}
