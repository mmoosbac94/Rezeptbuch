import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/usecases/appbar_usecase.dart';
import 'package:recipeWebApp/usecases/recipe_usecase.dart';

import 'add_recipe_dialog.dart';

class RecipeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const RecipeAppBar({this.title});

  @override
  _RecipeAppBarState createState() => _RecipeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}

class _RecipeAppBarState extends State<RecipeAppBar> {
  final TextEditingController _searchQueryController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppBarUseCase>(builder: (_, appBarUseCase, __) {
      return AppBar(
          backgroundColor: Colors.orange,
          title: appBarUseCase.state is AppBarUseCaseInitial ||
                  appBarUseCase.state is AppBarUseCaseDefault
              ? Text(widget.title)
              : _buildSearchField(),
          leading: appBarUseCase.state is AppBarUseCaseInitial ||
                  appBarUseCase.state is AppBarUseCaseDefault
              ? Container()
              : _buildBackButton(),
          actions: _buildActions());
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

  Widget _buildBackButton() {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.read<AppBarUseCase>().resetSearching();
          context.read<RecipeUseCase>().showAllRecipesOfIndex();
        });
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
