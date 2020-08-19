import 'dart:convert';

import 'package:http/http.dart';
import 'package:recipeWebApp/abstract_webservice.dart';
import 'package:recipeWebApp/models/recipe.dart';

class Webservice extends AbstractWebservice {
  String baseURL = 'http://localhost:9200';

  Webservice();

  @override
  Future<Result> request() async {
    String url = _buildURL;
    Response response = await get(url);
    if (response.statusCode == 200) {
      print("SUCCESS");
      final jsonResponse = json.decode(response.body);
      Result result = Result.fromJson(jsonResponse);
      print("WHAT: " + result.hits.hits[0].source.recipes[0].name);
      return result;
    } else {
      print("not successfully");
    }
    return null;
  }

  String get _buildURL {
    return baseURL + '/recipes/_search';
  }
}
