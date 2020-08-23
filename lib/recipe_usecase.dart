import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/recipe_repository.dart';

class RecipeUseCase {
  RecipeRepository recipeRepository;

  RecipeUseCase(this.recipeRepository);


  Future<Result> getAllRecipesOfIndex() async {
    return await recipeRepository.getAllRecipesOfIndex();
  }

  Future<Result> getRecipesByQuery(String query) async {
    return await recipeRepository.getRecipesByQuery(query);
  }

}
