import 'package:shoppingmobile/datas/products.dart';

class CartItem {
  int quantity;
  String details;

  //armazenar os produtos do carrinho
  Product product;

  CartItem(this.product, this.quantity, this.details);

  Map<String, dynamic> toMap() {
    return {"product_id": product.id, "quantity": quantity, "details": details};
  }

  Map<String, dynamic> toJson() {
    return {"details": details, "quantity": quantity, "product_id": product.id};
  }

  factory CartItem.fromJson(dynamic json) {
    return CartItem(
        new Product(json['product_id'] as int, null, null, 0.0, null, null, 0),
        json['quantity'] as int,
        json["details"] as String);
  }

  getAmount() {
    return quantity * product.price;
  }
}
