import 'package:flutter/material.dart';
import 'package:recipeWebApp/models/recipe.dart';

abstract class AbstractWebservice {
  Future<Result> getRecipes({String query});

  Future<String> addRecipe({@required Recipe recipe});

  Future<String> removeRecipe({@required Document document});

  Future<String> editRecipe({@required Recipe recipe, @required String id});
}