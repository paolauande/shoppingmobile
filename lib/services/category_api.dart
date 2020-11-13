import 'dart:convert';
import 'package:shoppingmobile/datas/category.dart';
import 'package:shoppingmobile/models/login.dart';
import 'package:shoppingmobile/widgets/config.dart';
import 'package:http/http.dart' as http;

class CategoryApi {
  static Future<List<Category>> getCategories() async {
    List<Category> categories;
    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };
    var url = Environment.API_ENDPOINT + "/api/categories";

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);

      Iterable listaResponse = mapResponse['data'];

      categories =
          listaResponse.map((model) => Category.fromJson(model)).toList();
    } else {
      categories = null;
    }
    if (categories != null) print("getCategories: " + categories.toString());
    return categories;
  }
}
