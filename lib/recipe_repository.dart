import 'package:recipeWebApp/abstract_recipe_repository.dart';
import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/webservice.dart';

class RecipeRepository extends AbstractRecipeRepository {

  Webservice webservice;

  RecipeRepository(this.webservice);

  @override
  Future<Result> getAllRecipesOfIndex() async {
    return await webservice.request();
  }


}