import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/usecases/ingredient_usecase.dart';
import 'package:recipeWebApp/usecases/recipe_usecase.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/userinterface/delete_dialog.dart';
import 'package:recipeWebApp/userinterface/ingredients_adder.dart';

// ignore: must_be_immutable
class CustomRecipeForm extends StatefulWidget {
  Document document;
  bool isEditMode = false;

  CustomRecipeForm.create();

  CustomRecipeForm.edit({@required this.document}) {
    isEditMode = true;
  }

  @override
  CustomFormState createState() {
    return CustomFormState();
  }
}

class CustomFormState extends State<CustomRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController recipeNameController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController recipePersonController = TextEditingController();
  final TextEditingController recipeTimeController = TextEditingController();
  final TextEditingController recipePreparationController =
      TextEditingController();
  final TextEditingController recipeTipController = TextEditingController();
  final ValueNotifier<String> dropDownNotifier =
      ValueNotifier<String>('Fleisch');

  @override
  void initState() {
    if (widget.isEditMode) {
      recipeNameController.text = widget.document.recipe.name;
      Provider.of<IngredientUseCase>(context, listen: false)
          .ingredientsList
          .addAll(widget.document.recipe.ingredients);
      recipePersonController.text = widget.document.recipe.persons.toString();
      recipeTimeController.text = widget.document.recipe.time.toString();
      recipePreparationController.text = widget.document.recipe.preparation;
      recipeTipController.text = widget.document.recipe.tip;
      dropDownNotifier.value = widget.document.recipe.category;
    } else {
      Provider.of<IngredientUseCase>(context, listen: false)
          .ingredientsList
          .clear();
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          width: 500,
          child: Column(children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Bitte einen Namen eingeben';
                }
                return null;
              },
              controller: recipeNameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            CategoriesDropDown(dropDownNotifier: dropDownNotifier),
            IngredientsAdder(controller: ingredientController),
            TextFormField(
                controller: recipePreparationController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bitte eine Zubereitung eingeben';
                  }
                  return null;
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(labelText: 'Zubereitung')),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Bitte die Anzahl der Personen angeben';
                }
                return null;
              },
              controller: recipePersonController,
              decoration: const InputDecoration(labelText: 'Personen'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bitte eine Zubereitungszeit angeben';
                  }
                  return null;
                },
                controller: recipeTimeController,
                decoration: const InputDecoration(labelText: 'Dauer'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ]),
            TextFormField(
                controller: recipeTipController,
                decoration:
                    const InputDecoration(labelText: 'Tipp (Optional)')),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _buildRecipe();
                    if (!widget.isEditMode) {
                      context.read<IngredientUseCase>().ingredientsList.clear();
                    }
                  }
                },
                child: (!widget.isEditMode)
                    ? const Text('Erstellen')
                    : const Text('Ändern'),
              ),
            ),
            if (widget.document != null)
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog<dynamic>(
                      context: context,
                      builder: (context) =>
                          DeleteDialog(document: widget.document)))
          ]),
        ));
  }

  Future<void> _buildRecipe() async {
    final Recipe recipe = Recipe(
        name: recipeNameController.text,
        category: dropDownNotifier.value,
        ingredients: context.read<IngredientUseCase>().ingredientsList,
        persons: int.parse(recipePersonController.text),
        preparation: recipePreparationController.text,
        time: int.parse(recipeTimeController.text),
        tip: recipeTipController.text);
    if (!widget.isEditMode) {
      await context
          .read<RecipeUseCase>()
          .addRecipe(recipe: recipe, context: context);
    } else {
      await context
          .read<RecipeUseCase>()
          .editRecipe(id: widget.document.id, recipe: recipe, context: context);
    }
  }
}

class CategoriesDropDown extends StatelessWidget {
  final ValueNotifier<String> dropDownNotifier;

  const CategoriesDropDown({@required this.dropDownNotifier});

  static final List<String> categories = [
    'Fleisch',
    'Fisch',
    'Pasta',
    'Vegetarisch',
    'Suppe',
    'Dessert',
    'Sauce',
    'Snack'
  ];

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
