import 'package:shoppingmobile/datas/address.dart';
import 'package:shoppingmobile/datas/cart_item.dart';
import 'package:shoppingmobile/datas/freight.dart';
import 'package:shoppingmobile/datas/order.dart';
import 'package:shoppingmobile/datas/payment.dart';
import 'package:shoppingmobile/datas/products.dart';
import 'package:shoppingmobile/models/login.dart';
import 'package:shoppingmobile/datas/user.dart';
import 'package:shoppingmobile/services/orders_api.dart';
import 'package:shoppingmobile/services/product_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartModel with ChangeNotifier {
  User user;
  Payment payment;
  Freight freight;
  Address address;
  List<CartItem> cartList = [];

  CartModel() {
    if (Login.getToken() != null) {
      getUser();
      if (cartList.length == 0) {
        loadCartListFromMap();
      }
    }
  }

  String _generateKey(String key) {
    Login.getUser().then((onValue) {
      String userId = user.id.toString();
      return '$userId/$key';
    });
    return key;
  }

  getUser() async {
    user = await Login.getUser();
  }

  void saveObject(String key, Map<String, dynamic> object) async {
    final prefs = await SharedPreferences.getInstance();

    final string = JsonEncoder().convert(object);

    await prefs.setString(_generateKey(key), string);
  }

  Future<Map<String, dynamic>> getObject(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final objectString = prefs.getString(_generateKey(key));

    if (objectString != null)
      return JsonDecoder().convert(objectString) as Map<String, dynamic>;
    return null;
  }

  Future<void> removeObject(String key) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove(_generateKey(key));
  }

  Future<Product> getProduct(int productId) async {
    return await ProductApi.getProductById(productId);
  }

  loadCartListFromMap() async {
    Map<String, dynamic> jsonCartList = await getObject("Cart");
    if (jsonCartList != null) {
      cartList =
          jsonCartList.entries.map((e) => CartItem.fromJson(e.value)).toList();
      for (var cartItem in cartList) {
        ProductApi.getProductById(cartItem.product.id).then((onValue) {
          cartItem.product = onValue;
        });
      }
    }
  }

  void addToCart(CartItem inCartItem) async {
    if (cartList == null) {
      cartList = new List<CartItem>();
    }
    for (var cartItem in cartList) {
      if (cartItem.product.id == inCartItem.product.id) {
        cartItem.quantity += 1;
        saveObject("Cart", this.toMap());
        return;
      }
    }
    cartList.add(inCartItem);
    saveObject("Cart", this.toMap());
    notifyListeners();
  }

  void removeCartItem(CartItem cartItem) {
    cartList.remove(cartItem);
    saveObject("Cart", this.toMap());
    if (cartList.isEmpty) {
      payment = null;
      freight = null;
      address = null;
    }
    notifyListeners();
  }

  void addQuantity(CartItem inCartItem) {
    for (var cartItem in cartList) {
      if (cartItem.product.id == inCartItem.product.id) {
        cartItem.quantity += 1;
        saveObject("Cart", this.toMap());
        notifyListeners();
        return;
      }
    }
  }

  void removeQuantity(CartItem inCartItem) {
    for (var cartItem in cartList) {
      if (cartItem.product.id == inCartItem.product.id) {
        if (cartItem.quantity > 1) {
          cartItem.quantity -= 1;
        }
        saveObject("Cart", this.toMap());
        notifyListeners();
        return;
      }
    }
  }

  double getSubTotal() {
    double total = 0.0;
    if (cartList != null) {
      for (var cartItem in cartList) {
        total += cartItem.getAmount();
      }
    }
    return total;
  }

  double getTotal() {
    if (freight == null) {
      return this.getSubTotal();
    } else
      return this.getSubTotal() + this.freight.value;
  }

  double getShipPrice() {
    if (freight == null) {
      return 0.0;
    } else
      return this.freight.value;
  }

  setAddress(Address address) async {
    this.address = address;
    await OrdersApi.getFreightByNeighborhood(address.neighborhood)
        .then((onValue) {
      this.freight = onValue;
    });
    notifyListeners();
  }

  setFreight(Freight freight) {
    this.freight = freight;
    notifyListeners();
  }

  setPayment(Payment payment) {
    this.payment = payment;
    notifyListeners();
  }

  getOrder() {
    Order order = new Order(address.id, getTotal(), payment.id, getShipPrice());
    order.orderList = new List<OrderItem>();
    for (var cartItem in cartList) {
      order.orderList.add(new OrderItem(
          cartItem.product.id, cartItem.quantity, cartItem.details));
    }
    return order;
  }

  reset() {
    payment = null;
    freight = null;
    address = null;
    cartList = null;
    removeObject("Cart");
  }

  bool isValid() {
    if (getTotal() == null ||
        freight == null ||
        payment == null ||
        address == null) {
      return false;
    }
    return true;
  }

  String getRequiredField() {
    String fields = "";
    if (freight == null) {
      fields = "Taxa de entrega\n";
    }
    if (payment == null) {
      fields = fields + "Forma de Pagamento\n";
    }
    if (address == null) {
      fields = fields + "Endereço\n";
    }
    return fields;
  }

  toMap() {
    Map<String, dynamic> map2 = {};
    cartList.forEach(
        (cartItem) => map2[cartItem.product.id.toString()] = cartItem.toJson());
    return map2;
  }
}
