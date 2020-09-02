import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/recipe_usecase.dart';

import 'models/recipe.dart';

class AddRecipeDialog extends StatelessWidget {

  final recipeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Column(
      children: <Widget>[
        Text('Füge ein neues Rezept hinzu...'),
        CustomForm(),
      ],
    ));
  }
}

class CustomForm extends StatefulWidget {
  @override
  CustomFormState createState() {
    return CustomFormState();
  }
}

class CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          width: 500,
          child: Column(children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Kategorie'),
            ),
            TextFormField(decoration: InputDecoration(labelText: 'Zutaten')),
            TextFormField(
                decoration: InputDecoration(labelText: 'Zubereitung')),
            TextFormField(
              decoration: InputDecoration(labelText: 'Personen'),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
            TextFormField(
                decoration: InputDecoration(labelText: 'Dauer'),
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ]),
            TextFormField(
                decoration: InputDecoration(labelText: 'Tipp (Optional)')),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: _createAndPostRecipe,
                child: Text('Erstellen'),
              ),
            )
          ]),
        ));
  }

  _createAndPostRecipe() async {
    Recipe recipe = Recipe(
        name: 'TestName',
        category: 'TestCategory',
        ingredients: ['Test1', 'Test2', 'Test3'],
        persons: 2,
        preparation: 'TestPreparation',
        time: 20,
        tip: 'TestTip');
    String response = await context
        .read<RecipeUseCase>()
        .addRecipe(recipe: recipe, context: context);
  }
}
