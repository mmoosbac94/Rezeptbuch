import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/recipe_repository.dart';

class RecipeUseCase {
  RecipeRepository recipeRepository;

  RecipeUseCase(this.recipeRepository);


  Future<Result> getAllRecipesOfIndex() {
    return recipeRepository.getAllRecipesOfIndex();
  }

}
