import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:recipeWebApp/abstract_webservice.dart';
import 'package:recipeWebApp/models/recipe.dart';

class Webservice extends AbstractWebservice {
  String baseURL = 'https://elasticsearch.cr0wd.net';

  Webservice();

  @override
  Future<Result> getRecipes({String query}) async {
    String url;

    if (query == null) {
      url = _buildURLForAllRecipes;
    } else {
      url = _buildURLForQuery(query);
    }
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
    return null;
  }

  String get _buildURLForAllRecipes {
    return baseURL + '/rezepte/_search?size=1000';
  }

  String _buildURLForQuery(String query) {
    return baseURL + '/rezepte/_search?q=*$query*?size=1000';
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

  @override
  Future<String> editRecipe(
      {@required String id, @required Recipe recipe}) async {
    final String url = baseURL + '/rezepte/rezept/$id?refresh=wait_for';
    final Response response = await put(url,
        body: jsonEncode(recipe),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    if (response.statusCode == 201) {
      return 'Success editing recipe';
    }
    return 'Error';
  }

  @override
  Future<String> removeRecipe({Document document}) async {
    final String url =
        baseURL + '/rezepte/rezept/${document.id}?refresh=wait_for';
    final Response response = await delete(url);
    if (response.statusCode == 200) {
      return 'Recipe was successfully deleted';
    }
    return 'Error removing recipe';
  }
}
