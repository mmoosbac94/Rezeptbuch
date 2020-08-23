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
        child: FutureBuilder<Result>(
            future: context.watch<RecipeUseCase>().getAllRecipesOfIndex(),
            builder:
                (BuildContext context, AsyncSnapshot<Result> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return RecipeListView(result: snapshot.data);
              } else {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                );
              }
            }),
      ),
    );
  }
}

class RecipeListView extends StatelessWidget {
  final Result result;

  RecipeListView({@required this.result});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: result.hits.hits.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.all(30),
        itemBuilder: (context, index) {
          return RecipeCard(document: result.hits.hits[index]);
        });
  }
}

class RecipeCard extends StatelessWidget {
  final Document document;

  RecipeCard({this.document});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(
        child: Column(children: [
          ListTile(
              title: Text(document.source.recipes[0].name),
              subtitle: Text(document.source.recipes[0].time.toString())),
          FlatButton(child: Text('Mehr erfahren...'), onPressed: null)
        ]),
      ),
    );
  }
}
