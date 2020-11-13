import 'package:shoppingmobile/datas/products.dart';

class Order {
  int id;
  int addressId;
  DateTime orderDate;
  String orderStatus;
  double totalAmount;
  int payTypeId;
  double delivery;
  List<OrderItem> orderList;

  Order(
    this.addressId,
    this.totalAmount,
    this.payTypeId,
    this.delivery,
  );

  Order.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    addressId = json['address_id'];
    orderDate = json['order_data'];
    orderStatus = json['order_status'];
    if (json['total_amount'] is double) {
      totalAmount = json['total_amount'];
    } else if (json['total_amount'] is int) {
      totalAmount = double.parse(json['total_amount'].toString());
    }
    payTypeId = json['payment_type'];
    if (json['delivery_value'] is double) {
      delivery = json['delivery_value'];
    } else if (json['delivery_value'] is int) {
      delivery = double.parse(json['delivery_value'].toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'address_id': addressId,
        'order_data': orderDate,
        'order_status': orderStatus,
        'total_amount': totalAmount,
        'payment_type': payTypeId,
        'delivery_value': delivery
      };

  double getSubTotal() {
    double total = 0.0;
    if (orderList != null) {
      for (var orderItem in orderList) {
        total += orderItem.amount;
      }
    }
    return total;
  }

  double getTotal() {
    if (delivery == null) {
      return this.getSubTotal();
    } else
      return this.getSubTotal() + this.delivery;
  }

  double getShipPrice() {
    if (delivery == null) {
      return 0.0;
    } else
      return this.delivery;
  }
}

class OrderItem {
  int id;
  int userId;
  int productId;
  Product product;
  int amount;
  int orderId;
  String details;

  OrderItem(this.productId, this.amount, this.details);

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json['user_id'];
    productId = json['product_id'];
    amount = json['amount'];
    orderId = json['order_id'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'amount': amount,
        'order_id': orderId,
        'details': details,
      };
}
