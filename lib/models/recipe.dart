class Recipe {
  final String title;
  final String time;
  final List<String> ingredients;
  final String cuisine;
  final int servings;
  final List<String> steps;

  Recipe({
    required this.title,
    required this.time,
    required this.ingredients,
    required this.cuisine,
    required this.servings,
    required this.steps,
  });
}
