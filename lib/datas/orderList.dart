import 'package:shoppingmobile/datas/order.dart';

class OrderList {
  List<Order> orders;
  String nextPageUrl;
  bool isLoading;
  int totalItems;
  OrderList(this.orders, this.nextPageUrl, this.isLoading, this.totalItems);

  bool isEndOfItems() {
    return orders != null && orders.length == totalItems;
  }
}
