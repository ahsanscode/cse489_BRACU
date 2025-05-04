import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../providers/auth_provider.dart';
import 'recipe_detail_screen.dart';
import '../widgets/app_drawer.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final favoriteIds = authProvider.currentUser?.favorites ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      drawer: AppDrawer(),
      body: FutureBuilder<List<Recipe>>(
        future: RecipeService().getRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final recipes = snapshot.data?.where((r) => favoriteIds.contains(r.id)).toList() ?? [];
          if (recipes.isEmpty) {
            return Center(child: Text('No favorite recipes.'));
          }
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                child: ListTile(
                  leading: Image.asset(recipe.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(recipe.title),
                  subtitle: Text(recipe.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}