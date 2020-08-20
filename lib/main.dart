import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/recipe_repository.dart';
import 'package:recipeWebApp/recipe_usecase.dart';
import 'package:recipeWebApp/webservice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Webservice webservice = Webservice();
    final RecipeRepository recipeRepository = RecipeRepository(webservice);

    return Provider(
      create: (_) => RecipeUseCase(recipeRepository),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter-Elastic-Rezeptbuch'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Result>(
                future: context.watch<RecipeUseCase>().getAllRecipesOfIndex(),
                builder:
                    (BuildContext context, AsyncSnapshot<Result> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.hits.hits.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return RecipeWidget(document: snapshot.data.hits.hits[index]);
                        });
                  } else {
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}

class RecipeWidget extends StatelessWidget {
  final Document document;

  RecipeWidget({this.document});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(document.source.recipes[0].name),
      Text(document.source.recipes[0].preparation),
      Text('TEST')
    ]);
  }
}
