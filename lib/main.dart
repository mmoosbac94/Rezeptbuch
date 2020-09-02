import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/usecases/appbar_usecase.dart';
import 'package:recipeWebApp/recipe_repository.dart';
import 'package:recipeWebApp/usecases/recipe_usecase.dart';
import 'package:recipeWebApp/userinterface/recipe_app_bar.dart';
import 'package:recipeWebApp/userinterface/recipe_page_body.dart';
import 'package:recipeWebApp/webservice.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Webservice webservice = Webservice();
    final RecipeRepository recipeRepository = RecipeRepository(webservice);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppBarUseCase>(create: (_) => AppBarUseCase()),
        ChangeNotifierProvider<RecipeUseCase>(
            create: (_) => RecipeUseCase(recipeRepository))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: RecipesPage(title: 'Flutter-Elastic-Rezeptbuch'),
      ),
    );
  }
}

class RecipesPage extends StatelessWidget {
  final String title;

  const RecipesPage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: RecipeAppBar(title: title), body: RecipePageBody());
  }
}
