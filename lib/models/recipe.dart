class Recipe {
  String id;
  String title;
  String description;
  String ingredients;
  String instructions;
  String imageUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'ingredients': ingredients,
        'instructions': instructions,
        'imageUrl': imageUrl,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        ingredients: json['ingredients'],
        instructions: json['instructions'],
        imageUrl: json['imageUrl'],
      );
}