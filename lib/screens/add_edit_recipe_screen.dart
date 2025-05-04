import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  AddEditRecipeScreen({this.recipe});

  @override
  _AddEditRecipeScreenState createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title, description, ingredients, instructions, imageUrl;
  final List<String> imageOptions = [
    'assets/images/pizza.jpg',
    'assets/images/pasta.jpg',
  ];

  @override
  void initState() {
    super.initState();
    title = widget.recipe?.title ?? '';
    description = widget.recipe?.description ?? '';
    ingredients = widget.recipe?.ingredients ?? '';
    instructions = widget.recipe?.instructions ?? '';
    imageUrl = widget.recipe?.imageUrl ?? imageOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit Recipe')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                initialValue: ingredients,
                decoration: InputDecoration(labelText: 'Ingredients'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => ingredients = value!,
              ),
              TextFormField(
                initialValue: instructions,
                decoration: InputDecoration(labelText: 'Instructions'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => instructions = value!,
              ),
              DropdownButtonFormField<String>(
                value: imageUrl,
                decoration: InputDecoration(labelText: 'Image'),
                items: imageOptions
                    .map((img) => DropdownMenuItem(value: img, child: Text(img)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    imageUrl = value!;
                  });
                },
                validator: (value) => value == null ? 'Required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final recipe = Recipe(
                      id: widget.recipe?.id ?? Uuid().v4(),
                      title: title,
                      description: description,
                      ingredients: ingredients,
                      instructions: instructions,
                      imageUrl: imageUrl,
                    );
                    final service = RecipeService();
                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Center(child: CircularProgressIndicator()),
                      );
                      if (widget.recipe == null) {
                        await service.addRecipe(recipe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Recipe added successfully')),
                        );
                      } else {
                        await service.updateRecipe(recipe.id, recipe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Recipe updated successfully')),
                        );
                      }
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close screen
                    } catch (e) {
                      Navigator.pop(context); // Close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: Text(widget.recipe == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}