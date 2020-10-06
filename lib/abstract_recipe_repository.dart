import 'package:flutter/material.dart';
import 'package:recipeWebApp/models/recipe.dart';

abstract class AbstractRecipeRepository {
  Future<Result> getAllRecipesOfIndex();

  Future<Result> getRecipesByQuery(String query);

  Future<String> addRecipe({Recipe recipe});

  Future<String> removeRecipe({Document document});

  Future<String> editRecipe({@required Recipe recipe, @required String id});
}
