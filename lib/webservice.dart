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
      String url = _buildURLForAllRecipes;
      Response response = await get(url);
      if (response.statusCode == 200) {
        print('Success');
        final jsonResponse = json.decode(response.body);
        Result result = Result.fromJson(jsonResponse);
        return result;
      } else {
        print('not successfully');
      }
      return null;
    } else {
      String url = _buildURLForQuery(query);
      Response response = await get(url);
      if (response.statusCode == 200) {
        print('Success');
        final jsonResponse = json.decode(response.body);
        Result result = Result.fromJson(jsonResponse);
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

  String _buildURLForQuery(query) {
    return baseURL + '/_search?q=$query';
  }
}
