import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String json;
  const RecipeCard({super.key, required this.json});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Recipe: $json'),
      ),
    );
  }
}
