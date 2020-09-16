import 'package:flutter/material.dart';
import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/usecases/recipe_usecase.dart';
import 'package:recipeWebApp/userinterface/recipe_view.dart';
import 'package:provider/provider.dart';

class RecipeGridView extends StatelessWidget {
  final Result result;

  const RecipeGridView({@required this.result});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GridView.count(
        shrinkWrap: true,
        childAspectRatio: _checkHeight(height, width),
        crossAxisCount: _checkCount(width),
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        padding: const EdgeInsets.all(20.0),
        children: List.generate(result.hits.hits.length,
            (index) => RecipeCard(document: result.hits.hits[index])));
  }
}

double _checkHeight(double height, double width) {
  if (width < 370) {
    return height * 0.002;
  } else {
    return height * 0.003;
  }
}

int _checkCount(double width) {
  if (width > 1100) {
    return 3;
  } else if (width <= 570) {
    return 1;
  } else if (width <= 1100) {
    return 2;
  }
  return 1;
}

class RecipeCard extends StatelessWidget {
  final Document document;

  const RecipeCard({this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(document.recipe.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Text(
                        'Zubereitungszeit: ${document.recipe.time.toString()} min.'),
                  ),
                  Text('${document.recipe.persons} Personen')
                ],
              ),
              trailing: Text(document.recipe.category)),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: RaisedButton(
                    onPressed: () => showDialog<dynamic>(
                        context: context,
                        builder: (context) =>
                            RecipeView(recipe: document.recipe)),
                    child: const Text('Mehr erfahren...'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => showDialog<dynamic>(
                          context: context,
                          builder: (context) =>
                              DeleteDialog(document: document)),
                      hoverColor: Colors.transparent,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final Document document;

  const DeleteDialog({this.document});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Willst du das Rezept wirklich löschen?'),
      actions: <Widget>[_yesButton(context), _noButton(context)],
    );
  }

  Widget _yesButton(BuildContext context) {
    return FlatButton(
        onPressed: () => Navigator.pop(context), child: const Text('Nein'));
  }

  Widget _noButton(BuildContext context) {
    return FlatButton(
        onPressed: () {
          Navigator.pop(context);
          context.read<RecipeUseCase>().removeRecipe(document: document);
        },
        child: const Text('Ja'));
  }
}