import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/appbar_usecase.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppBarUseCase, RecipeUseCase>(
        builder: (_, appBarUseCase, recipeUseCase, __) {
      return Scaffold(
          appBar: AppBar(
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
        onChanged: (query) =>
            context.read<RecipeUseCase>().showRecipesByQuery(query));
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
    ];
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
              trailing: Text(document.recipe.category)),
          FlatButton(child: Text('Mehr erfahren...'), onPressed: null)
        ]),
      ),
    );
  }
}
