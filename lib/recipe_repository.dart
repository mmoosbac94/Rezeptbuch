import 'package:flutter/material.dart';
import 'package:recipeWebApp/abstract_recipe_repository.dart';
import 'package:recipeWebApp/models/recipe.dart';
import 'package:recipeWebApp/webservice.dart';

class RecipeRepository extends AbstractRecipeRepository {

  Webservice webservice;

  RecipeRepository(this.webservice);

  @override
  Future<Result> getAllRecipesOfIndex() async {
    return webservice.getRecipes();
  }

  @override
  Future<Result> getRecipesByQuery(String query) async{
    return webservice.getRecipes(query: query);
  }

  @override
  Future<String> addRecipe({Recipe recipe}) async {
    return webservice.addRecipe(recipe: recipe);
  }

  @override
  Future<String> removeRecipe({Document document}) {
    return webservice.removeRecipe(document: document);
  }

  @override
  Future<String> editRecipe({@required Recipe recipe, @required String id}) {
    return webservice.editRecipe(id: id, recipe: recipe);
  }

  


}