import 'package:shoppingmobile/datas/products.dart';

class ProductList {
  List<Product> products;
  String nextPageUrl;
  bool isLoading;
  int totalItems;
  ProductList(this.products, this.nextPageUrl, this.isLoading, this.totalItems);

  bool isEndOfItems() {
    return products != null && products.length == totalItems;
  }
}
