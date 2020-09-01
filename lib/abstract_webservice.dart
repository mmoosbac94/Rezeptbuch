import 'package:recipeWebApp/models/recipe.dart';

abstract class AbstractWebservice {
  Future<Result> request({String query});

  Future<String> addRecipe({Recipe recipe});
}