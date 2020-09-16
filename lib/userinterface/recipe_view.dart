import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeWebApp/models/recipe.dart';

class RecipeView extends StatelessWidget {
  final Recipe recipe;

  const RecipeView({this.recipe});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0.0),
      title: Container(
          width: 50,
          height: 50,
          color: Colors.orange,
          child: Center(child: Text(recipe.name))),
      titleTextStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      content: _buildRecipeContent(),
      scrollable: true,
    );
  }

  Widget _buildRecipeContent() {
    return Container(
        width: 500,
        child: Column(children: <Widget>[
          _createIngredientsPart(),
          _divider(),
          _createPreparationPart(),
          _createTipPart()
        ]));
  }

  Widget _createIngredientsPart() {
    return Container(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child:
                Text('Zutaten', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Column(
              children: recipe.ingredients
                  .map((ingredient) => Text(ingredient))
                  .toList())
        ],
      ),
    );
  }

  Widget _createPreparationPart() {
    return Container(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Zubereitung',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(recipe.preparation)
        ],
      ),
    );
  }

  Widget _createTipPart() {
    return recipe.tip.isNotEmpty
        ? Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: RichText(
              text: TextSpan(children: [
                const TextSpan(
                    text: 'Tipp: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: recipe.tip)
              ], style: TextStyle(color: Colors.black)),
            ),
        )
        : Container();
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0, top: 25),
      child: Container(height: 2, color: Colors.orange),
    );
  }
}
