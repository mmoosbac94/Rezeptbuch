import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/usecases/ingredient_usecase.dart';
import 'package:recipeWebApp/userinterface/custom_recipe_form.dart';

class AddRecipeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Füge ein neues Rezept hinzu...'),
      actions: <Widget>[
        InkWell(
            onTap: () => context.read<IngredientUseCase>().cancel(context),
            child: const Text('Cancel'))
      ],
      scrollable: true,
      content: const CustomRecipeForm(),
    );
  }
}
