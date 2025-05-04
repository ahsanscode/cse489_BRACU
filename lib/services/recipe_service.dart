import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/recipe.dart';

class RecipeService {
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/recipes.json');
  }

  Future<List<Recipe>> getRecipes() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        await file.writeAsString('[]'); // Initialize empty JSON if file doesn't exist
        return [];
      }
      final String content = await file.readAsString();
      final List<dynamic> json = jsonDecode(content);
      return json.map((e) => Recipe.fromJson(e)).toList();
    } catch (e) {
      print('Error reading recipes: $e');
      return [];
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      final recipes = await getRecipes();
      recipes.add(recipe);
      final file = await _getFile();
      await file.writeAsString(jsonEncode(recipes.map((e) => e.toJson()).toList()));
      print('Recipe added: ${recipe.title}');
    } catch (e) {
      print('Error adding recipe: $e');
      throw Exception('Failed to add recipe');
    }
  }

  Future<void> updateRecipe(String id, Recipe updatedRecipe) async {
    try {
      final recipes = await getRecipes();
      final index = recipes.indexWhere((r) => r.id == id);
      if (index == -1) {
        print('Recipe not found for ID: $id');
        throw Exception('Recipe not found');
      }
      recipes[index] = updatedRecipe;
      final file = await _getFile();
      await file.writeAsString(jsonEncode(recipes.map((e) => e.toJson()).toList()));
      print('Recipe updated: ${updatedRecipe.title}');
    } catch (e) {
      print('Error updating recipe: $e');
      throw Exception('Failed to update recipe');
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      final recipes = await getRecipes();
      final initialLength = recipes.length;
      recipes.removeWhere((r) => r.id == id);
      if (recipes.length == initialLength) {
        print('Recipe not found for ID: $id');
        throw Exception('Recipe not found');
      }
      final file = await _getFile();
      await file.writeAsString(jsonEncode(recipes.map((e) => e.toJson()).toList()));
      print('Recipe deleted: $id');
    } catch (e) {
      print('Error deleting recipe: $e');
      throw Exception('Failed to delete recipe');
    }
  }
}