import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/appbar_usecase.dart';
import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/recipe_repository.dart';
import 'package:recipeWebApp/recipe_usecase.dart';
import 'package:recipeWebApp/webservice.dart';

import 'add_recipe_dialog.dart';

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
  final TextEditingController _searchQueryController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppBarUseCase, RecipeUseCase>(
        builder: (_, appBarUseCase, recipeUseCase, __) {
      return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.orange,
              title: appBarUseCase.state is AppBarUseCaseInitial ||
                      appBarUseCase.state is AppBarUseCaseDefault
                  ? Text(widget.title)
                  : _buildSearchField(),
              leading: appBarUseCase.state is AppBarUseCaseInitial ||
                      appBarUseCase.state is AppBarUseCaseDefault
                  ? Container()
                  : _buildBackButton(),
              actions: _buildActions()),
          body: _createBody(recipeUseCase, appBarUseCase));
    });
  }

  Widget _createBody(RecipeUseCase recipeUseCase, AppBarUseCase appBarUseCase) {
    print("STATEINFO: ${recipeUseCase.state}");
    if (recipeUseCase.state is RecipeUseCaseInitial) {
      recipeUseCase.showAllRecipesOfIndex();
    } else if (recipeUseCase.state is RecipeUseCaseLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (recipeUseCase.state is RecipeUseCaseSuccess) {
      return RecipeListView(
          result: (recipeUseCase.state as RecipeUseCaseSuccess).result);
    }
    return Container();
  }

  Widget _buildBackButton() {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.read<AppBarUseCase>().resetSearching();
          context.read<RecipeUseCase>().showAllRecipesOfIndex();
        });
  }

  Widget _buildSearchField() {
    return TextField(
        controller: _searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Search Data...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white30),
        ),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
        onChanged: (query) => _debouncer.run(
            () => context.read<RecipeUseCase>().showRecipesByQuery(query)));
  }

  List<Widget> _buildActions() {
    if (context.read<AppBarUseCase>().state is AppBarUseCaseSearch) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              return;
            }
            _searchQueryController.clear();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => context.read<AppBarUseCase>().startSearching(),
      ),
      IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => showDialog(
              context: context, builder: (context) => AddRecipeDialog())),
    ];
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
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
            padding: EdgeInsets.only(top: 15),
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
