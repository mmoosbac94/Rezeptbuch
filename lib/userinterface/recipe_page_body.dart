import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeWebApp/usecases/recipe_usecase.dart';
import 'package:recipeWebApp/userinterface/recipe_gridview.dart';

class RecipePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeUseCase>(builder: (_, recipeUseCase, __) {
      print("STATEINFO: ${recipeUseCase.state}");
      if (recipeUseCase.state is RecipeUseCaseInitial) {
        recipeUseCase.showAllRecipesOfIndex();
      } else if (recipeUseCase.state is RecipeUseCaseLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (recipeUseCase.state is RecipeUseCaseSuccess) {
        if ((recipeUseCase.state as RecipeUseCaseSuccess)
            .result
            .hits
            .hits
            .isEmpty) {
          return const Text('Es wurde nichts gefunden...');
        }
        return RecipeGridView(
            result: (recipeUseCase.state as RecipeUseCaseSuccess).result);
      }
      return Container();
    });
  }
}
