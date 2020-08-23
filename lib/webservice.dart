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
      String url = _buildURL;
      Response response = await get(url);
      if (response.statusCode == 200) {
        print("SUCCESS");
        final jsonResponse = json.decode(response.body);
        Result result = Result.fromJson(jsonResponse);
        return result;
      } else {
        print("not successfully");
      }
      return null;
    } else {
      return null;
    }
  }

  String get _buildURL {
    return baseURL + '/recipes/_search';
  }
}
