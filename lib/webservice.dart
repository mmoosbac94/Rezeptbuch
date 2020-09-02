import 'dart:convert';

import 'package:http/http.dart';
import 'package:recipeWebApp/abstract_webservice.dart';
import 'package:recipeWebApp/models/recipe.dart';

class Webservice extends AbstractWebservice {
  String baseURL = 'http://localhost:9200';

  Webservice();

  @override
  Future<Result> request({String query}) async {
    if (query == null) {
      final String url = _buildURLForAllRecipes;
      final Response response = await get(url);
      if (response.statusCode == 200) {
        print('Success getting all recipes');
        final dynamic jsonResponse = json.decode(response.body);
        final Result result =
            Result.fromJson(jsonResponse as Map<String, dynamic>);
        return result;
      } else {
        print('not successfully');
      }
      return null;
    } else {
      final String url = _buildURLForQuery(query);
      final Response response = await get(url);
      if (response.statusCode == 200) {
        print('Success query');
        final dynamic jsonResponse = json.decode(response.body);
        final Result result =
            Result.fromJson(jsonResponse as Map<String, dynamic>);
        return result;
      } else {
        print('not successfully');
      }
    }
    return null;
  }

  String get _buildURLForAllRecipes {
    return baseURL + '/rezepte/_search';
  }

  String _buildURLForQuery(String query) {
    return baseURL + '/_search?q=$query';
  }

  @override
  Future<String> addRecipe({Recipe recipe}) async {
    final String url = baseURL + '/rezepte/rezept?refresh=wait_for';
    final Response response = await post(url,
        body: jsonEncode(recipe),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    if (response.statusCode == 201) {
      return 'Success adding recipe';
    }
    return 'Error';
  }
}
