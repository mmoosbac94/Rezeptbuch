import 'package:recipeWebApp/models/recipe.dart';

abstract class AbstractWebservice {
  Future<Result> request({String query});
}