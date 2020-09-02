import 'package:flutter/material.dart';
import 'package:recipeWebApp/models/recipe.dart';

class RecipeListView extends StatelessWidget {
  final Result result;

  const RecipeListView({@required this.result});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: result.hits.hits.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(30),
        itemBuilder: (context, index) {
          return RecipeCard(document: result.hits.hits[index]);
        });
  }
}

class RecipeCard extends StatelessWidget {
  final Document document;

  const RecipeCard({this.document});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(
        child: Column(children: [
          ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(document.recipe.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
            padding: const EdgeInsets.only(top: 15),
            child: Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.orange),
              child: ExpansionTile(
                title: Text(
                  'Mehr erfahren...',
                  style: TextStyle(color: Colors.orange),
                ),
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10, left: 20),
                        child: Text(document.recipe.preparation),
                      ))
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}