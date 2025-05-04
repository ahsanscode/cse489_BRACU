import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/app_drawer.dart';
import 'recipe_detail_screen.dart';
import 'add_edit_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Recipe>>? _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = RecipeService().getRecipes();
  }

  void _refreshRecipes() {
    setState(() {
      _recipesFuture = RecipeService().getRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe App')),
      drawer: AppDrawer(),
      body: FutureBuilder<List<Recipe>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading recipes: ${snapshot.error}'));
          }
          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return Center(child: Text('No recipes found. Add one!'));
          }
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: Image.asset(recipe.imageUrl, width: 50, height: 50),
                  title: Text(recipe.title),
                  subtitle: Text(recipe.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipe: recipe),
                      ),
                    ).then((_) => _refreshRecipes()); // Refresh on return
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditRecipeScreen()),
          ).then((_) => _refreshRecipes()); // Refresh on return
        },
        child: Icon(Icons.add),
      ),
    );
  }
}