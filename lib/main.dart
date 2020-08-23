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
  bool _isSearching = false;
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: _isSearching ? _buildSearchField() : Text(widget.title),
          leading: _isSearching ? _buildBackButton() : Container(),
          actions: _buildActions()),
      body: FutureBuilder<Result>(
          future: searchQuery.isEmpty
              ? context.watch<RecipeUseCase>().getAllRecipesOfIndex()
              : context.watch<RecipeUseCase>().getRecipesByQuery(searchQuery),
          builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return RecipeListView(result: snapshot.data);
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            }
          }),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        setState(() {
          searchQuery = "";
          _isSearching = false;
        });
      },
    );
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
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
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
              title: Text(document.recipe.name),
              subtitle: Text(document.recipe.time.toString()),
              trailing: Text(document.recipe.category)
              ),
          FlatButton(child: Text('Mehr erfahren...'), onPressed: null)
        ]),
      ),
    );
  }
}
