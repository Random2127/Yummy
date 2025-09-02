class Recipe {
  final String title;
  final String description;
  final int time;
  final int servings;
  final String cuisine;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.title,
    required this.description,
    required this.time,
    required this.servings,
    required this.cuisine,
    required this.ingredients,
    required this.instructions,
  });

  // Factory constructor to create a Recipe from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      description: json['description'],
      time: json['time'],
      ingredients: List<String>.from(json['ingredients']),
      cuisine: json['cuisine'],
      servings: json['servings'],
      instructions: List<String>.from(json['instructions']),
    );
  }

  // Method to convert Recipe to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'time': time,
      'ingredients': ingredients,
      'cuisine': cuisine,
      'servings': servings,
      'instructions': instructions,
    };
  }
}
