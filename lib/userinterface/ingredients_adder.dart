import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/usecases/ingredient_usecase.dart';

class IngredientsAdder extends StatelessWidget {
  final TextEditingController controller;

  const IngredientsAdder({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              validator: (value) {
                if (context.read<IngredientUseCase>().ingredientsList.isEmpty) {
                  return 'Es fehlt mindestens eine Zutat';
                }
                return null;
              },
              controller: controller,
              decoration: InputDecoration(
                  labelText: 'Zutaten',
                  suffixIcon: InkWell(
                    onTap: () => context
                        .read<IngredientUseCase>()
                        .addIngredient(controller),
                    child: const Icon(Icons.add_circle),
                  ))),
          Consumer<IngredientUseCase>(
            builder: (_, addRecipeUseCase, __) {
              if (addRecipeUseCase.ingredientsList.isNotEmpty) {
                return Wrap(
                    children: addRecipeUseCase.ingredientsList
                        .map((ingredient) => Container(
                            decoration: const BoxDecoration(
                                color: Colors.orange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            child: Text(ingredient,
                                style: const TextStyle(color: Colors.white))))
                        .toList());
              } else {
                return Container();
              }
            },
          )
        ]);
  }
}