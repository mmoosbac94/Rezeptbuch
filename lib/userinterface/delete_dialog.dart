import 'package:flutter/material.dart';
import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/usecases/recipe_usecase.dart';
import 'package:provider/provider.dart';

class DeleteDialog extends StatelessWidget {
  final Document document;

  const DeleteDialog({this.document});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Willst du das Rezept wirklich löschen?'),
      actions: <Widget>[_noButton(context), _yesButton(context)],
    );
  }

  Widget _noButton(BuildContext context) {
    return FlatButton(
        onPressed: () => Navigator.pop(context), child: const Text('Nein'));
  }

  Widget _yesButton(BuildContext context) {
    return FlatButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
          context.read<RecipeUseCase>().removeRecipe(document: document);
        },
        child: const Text('Ja'));
  }
}