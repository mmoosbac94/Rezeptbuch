import 'package:flutter/material.dart';
import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/userinterface/custom_recipe_form.dart';

class EditRecipeDialog extends StatelessWidget {
  final Document document;

  const EditRecipeDialog({@required this.document});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rezept bearbeiten'),
      content: CustomRecipeForm(document: document),
      scrollable: true,
    );
  }
}