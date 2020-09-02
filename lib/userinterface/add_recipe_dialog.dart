import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/usecases/recipe_usecase.dart';

class AddRecipeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const Text('Füge ein neues Rezept hinzu...'),
          CustomForm(),
        ],
      ),
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
  final TextEditingController recipeNameController = TextEditingController();
  final TextEditingController recipePersonController = TextEditingController();
  final TextEditingController recipeTimeController = TextEditingController();
  final TextEditingController recipeTipController = TextEditingController();
  final ValueNotifier<String> dropDownNotifier =
      ValueNotifier<String>('Fleisch');

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          width: 500,
          child: Column(children: <Widget>[
            TextFormField(
              controller: recipeNameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            CategoriesDropDown(dropDownNotifier: dropDownNotifier),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Zutaten')),
            TextFormField(
                maxLines: null,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Zubereitung')),
            TextFormField(
              controller: recipePersonController,
              decoration: const InputDecoration(labelText: 'Personen'),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
            TextFormField(
                controller: recipeTimeController,
                decoration: const InputDecoration(labelText: 'Dauer'),
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ]),
            TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Tipp (Optional)')),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: _createAndPostRecipe,
                child: const Text('Erstellen'),
              ),
            )
          ]),
        ));
  }

  Future<void> _createAndPostRecipe() async {
    final Recipe recipe = Recipe(
        name: recipeNameController.text,
        category: dropDownNotifier.value,
        ingredients: ['Test1', 'Test2', 'Test3'],
        persons: int.parse(recipePersonController.text),
        preparation: 'TestPreparation',
        time: int.parse(recipeTimeController.text),
        tip: recipeTipController.text);
    // final String response = await context
    //     .read<RecipeUseCase>()
    //     .addRecipe(recipe: recipe, context: context);
    await context
        .read<RecipeUseCase>()
        .addRecipe(recipe: recipe, context: context);
  }
}

class CategoriesDropDown extends StatelessWidget {
  final ValueNotifier<String> dropDownNotifier;

  const CategoriesDropDown({@required this.dropDownNotifier});

  static final List<String> categories = ['Fleisch', 'Suppe'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Row(children: <Widget>[Text(category)]),
        );
      }).toList(),
      onChanged: (String newCategory) {
        dropDownNotifier.value = newCategory;
      },
      value: dropDownNotifier.value,
      decoration: const InputDecoration(
          labelText: 'Kategorie',
          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20)),
    );
  }
}
