import 'package:flutter/material.dart';
import 'package:yummy/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              recipe.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(recipe.description, style: const TextStyle(fontSize: 14)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text('${recipe.time} mins'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.people, size: 16),
                    const SizedBox(width: 4),
                    Text('${recipe.servings} servings'),
                  ],
                ),
                Text(
                  recipe.cuisine,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            const Text(
              'Ingredients',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (var item in recipe.ingredients)
              Text('• $item', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            for (int i = 0; i < recipe.instructions.length; i++)
              Text(
                '${i + 1}. ${recipe.instructions[i]}',
                style: const TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}
