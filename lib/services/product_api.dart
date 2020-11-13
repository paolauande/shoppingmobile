import 'dart:convert';
import 'package:shoppingmobile/datas/productList.dart';
import 'package:shoppingmobile/datas/products.dart';
import 'package:shoppingmobile/models/login.dart';
import 'package:shoppingmobile/widgets/config.dart';
import 'package:http/http.dart' as http;

class ProductApi {
  static Future<List<Product>> getProducts() async {
    List<Product> products;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url = Environment.API_ENDPOINT + "/api/products";

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);

      List listaResponse = mapResponse['data'];

      products = listaResponse.map((model) => Product.fromJson(model)).toList();
    } else {
      products = null;
    }
    if (products != null) print("getProducts: " + products.toString());
    return products;
  }

  static Future<ProductList> getProductsByCategory(
      int categoryId, ProductList productList) async {
    if (productList == null) {
      productList = new ProductList(new List<Product>(), null, false, -1);
    }
    if (productList.isEndOfItems()) {
      return productList;
    }
    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };
    String url = "";
    if (productList.nextPageUrl == null || productList.nextPageUrl.isEmpty) {
      url = Environment.API_ENDPOINT +
          "/api/products?search=category_id:" +
          categoryId.toString() +
          '&orderBy=name&sortedBy=asc&page=1&limit=' +
          Environment.PAGE_LIMIT.toString();
    } else {
      url = productList.nextPageUrl;
    }

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);

      List listaResponse = mapResponse['data']['data'];

      List<Product> list = List<Product>();

      list = listaResponse.map((model) => Product.fromJson(model)).toList();
      if (productList.products == null) {
        productList.products = new List<Product>();
      }
      productList.products.addAll(list);
      productList.nextPageUrl = mapResponse['data']['next_page_url'];
      productList.totalItems = mapResponse['data']['total'];
    }
    if (productList != null)
      print("getProductsByCategory: " + productList.toString());
    return productList;
  }

  static Future<Product> getProductById(int productId) async {
    Product product;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url =
        Environment.API_ENDPOINT + "/api/products/" + productId.toString();

    var response = await http.get(url, headers: header);

    print("getProductById: statusCode [${response.statusCode}] ");

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      product = Product.fromJson(mapResponse['data']);
    } else {
      return null;
    }
    if (product != null) print("getProductById: " + product.toString());
    return product;
  }
}
