import 'dart:convert';

import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String json;
  const RecipeCard({super.key, required this.json});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = jsonDecode(json);
    final String title = data['title'] ?? 'Recipe';
    final String description = data['description'] ?? '';
    final int time = data['time'] ?? 0;
    final int servings = data['servings'] ?? 0;
    final String cuisine = data['cuisine'] ?? '';
    final List ingredients = data['ingredients'] ?? [];
    final List instructions = data['instructions'] ?? [];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text('$time mins'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.people, size: 16),
                    const SizedBox(width: 4),
                    Text('$servings servings'),
                  ],
                ),
                Text(
                  cuisine,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            Divider(height: 24, thickness: 1),
            const Text(
              'Ingredients',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (var item in ingredients)
              Text('• $item', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            for (int i = 0; i < instructions.length; i++)
              Text(
                '${i + 1}. ${instructions[i]}',
                style: const TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}
