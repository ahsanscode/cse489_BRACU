import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../providers/auth_provider.dart';
import 'add_edit_recipe_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isFavorite = authProvider.currentUser?.favorites.contains(recipe.id) ?? false;
    final isTried = authProvider.currentUser?.tried.contains(recipe.id) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              authProvider.toggleFavorite(recipe.id);
            },
          ),
          IconButton(
            icon: Icon(isTried ? Icons.check_circle : Icons.check_circle_outline),
            onPressed: () {
              authProvider.toggleTried(recipe.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(recipe.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(recipe.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(recipe.ingredients, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(recipe.instructions, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditRecipeScreen(recipe: recipe),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Center(child: CircularProgressIndicator()),
                      );
                      await RecipeService().deleteRecipe(recipe.id);
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close detail screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Recipe deleted successfully')),
                      );
                    } catch (e) {
                      Navigator.pop(context); // Close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete recipe: $e')),
                      );
                    }
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}