import 'package:recipeWebApp/models/recipe.dart';

abstract class AbstractRecipeRepository {

  Future<Result> getAllRecipesOfIndex();

  Future<Result> getRecipesByQuery(String query);

  Future<String> addRecipe({Recipe recipe});
}