import 'package:flutter/material.dart';
import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/recipe_repository.dart';

abstract class RecipeUseCaseState {
  RecipeUseCaseState();
}

class RecipeUseCaseInitial implements RecipeUseCaseState {
  const RecipeUseCaseInitial();
}

class RecipeUseCaseLoading implements RecipeUseCaseState {
  const RecipeUseCaseLoading();
}

class RecipeUseCaseSuccess implements RecipeUseCaseState {
  final Result result;

  const RecipeUseCaseSuccess({@required this.result});
}

class RecipeUseCase extends ChangeNotifier {
  RecipeUseCaseState _state;

  RecipeRepository recipeRepository;

  RecipeUseCase(this.recipeRepository);

  RecipeUseCaseState get state {
    return _state ??= const RecipeUseCaseInitial();
  }

  void _updateState(RecipeUseCaseState state) {
    if (state == _state) {
      return;
    }
    _state = state;
    notifyListeners();
  }

  Future<void> showAllRecipesOfIndex() async {
    _updateState(const RecipeUseCaseLoading());
    final Result result = await recipeRepository.getAllRecipesOfIndex();
    _updateState(RecipeUseCaseSuccess(result: result));
  }

  Future<void> showRecipesByQuery(String query) async {
    _updateState(const RecipeUseCaseLoading());
    final Result result = await recipeRepository.getRecipesByQuery(query);
    _updateState(RecipeUseCaseSuccess(result: result));
  }

  Future<String> addRecipe({Recipe recipe, BuildContext context}) async {
    Navigator.pop(context);
    _updateState(const RecipeUseCaseLoading());
    final String result = await recipeRepository.addRecipe(recipe: recipe);
    await showAllRecipesOfIndex();
    return result;
  }

  Future<String> editRecipe(
      {@required String id, @required Recipe recipe, @required BuildContext context}) async {
    Navigator.pop(context);
    _updateState(const RecipeUseCaseLoading());
    final String result = await recipeRepository.editRecipe(id: id, recipe: recipe);
    await showAllRecipesOfIndex();
    return result;
  }

  Future<String> removeRecipe({@required Document document}) async {
    _updateState(const RecipeUseCaseLoading());
    final String result =
        await recipeRepository.removeRecipe(document: document);
    await showAllRecipesOfIndex();
    return result;
  }
}
