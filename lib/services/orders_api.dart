import 'dart:convert';
import 'dart:io';

import 'package:shoppingmobile/datas/freight.dart';
import 'package:shoppingmobile/datas/freight_request.dart';
import 'package:shoppingmobile/datas/order.dart';
import 'package:shoppingmobile/datas/orderList.dart';
import 'package:shoppingmobile/datas/payment.dart';
import 'package:shoppingmobile/datas/products.dart';
import 'package:shoppingmobile/models/login.dart';
import 'package:shoppingmobile/services/product_api.dart';
import 'package:shoppingmobile/widgets/config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrdersApi {
  static Future<List<Payment>> getPayments() async {
    List<Payment> payments;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url = Environment.API_ENDPOINT + "/api/payments";

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);

      Iterable listaResponse = mapResponse['data'];

      payments = listaResponse.map((model) => Payment.fromJson(model)).toList();
    } else {
      payments = null;
    }
    if (payments != null) print("getPayments: " + payments.toString());
    return payments;
  }

  static Future<List<Freight>> getFreights() async {
    List<Freight> freights;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url = Environment.API_ENDPOINT + '/api/freights';

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);

      Iterable listaResponse = mapResponse['data'];

      freights = listaResponse.map((model) => Freight.fromJson(model)).toList();
    } else {
      freights = null;
    }
    if (freights != null) print("getFreights: " + freights.toString());
    return freights;
  }

  static Future<Freight> getFreightByNeighborhood(String neighborhood) async {
    Freight freight;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url =
        Environment.API_ENDPOINT + '/api/freights?search=name:' + neighborhood;

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      Iterable listaResponse = mapResponse['data'];
      List<Freight> freights =
          listaResponse.map((model) => Freight.fromJson(model)).toList();
      for (Freight freightResponse in freights) {
        if (freightResponse.name.toLowerCase() == neighborhood.toLowerCase()) {
          freight = freightResponse;
          break;
        }
      }
    } else {
      freight = null;
    }
    if (freight != null) print("getFreight: " + freight.toString());
    return freight;
  }

  static Future<OrderItem> saveItem(OrderItem orderItem, int orderId) async {
    var user = await Login.getUser();

    OrderItem orderItemSaved;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    Map paramsAdress = {
      "user_id": user.id,
      "product_id": orderItem.productId,
      "order_id": orderId,
      "amount": orderItem.amount,
    };

    if (orderItem.details != null && orderItem.details.isNotEmpty) {
      paramsAdress["details"] = orderItem.details;
    }

    var _body = json.encode(paramsAdress);

    var url = Environment.API_ENDPOINT + '/api/order_lists';

    var response = await http.post(url, headers: header, body: _body);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      orderItemSaved = OrderItem.fromJson(mapResponse['data']);
    } else {
      orderItemSaved = null;
    }
    if (orderItemSaved != null)
      print("orderItemSaved: " + orderItemSaved.toString());
    return orderItemSaved;
  }

  static Future<Order> checkout(Order order) async {
    var user = await Login.getUser();

    Order orderSaved;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };
    String formattedDate =
        DateFormat('yyyy-MM-dd hh:mm:ss').format(new DateTime.now());
    Map paramsAdress = {
      "user_id": user.id,
      "address_id": order.addressId,
      "total_amount": order.totalAmount,
      "payment_type": order.payTypeId,
      "delivery_value": order.delivery,
      "order_date": formattedDate,
      "order_status": "pending"
    };

    var _body = json.encode(paramsAdress);

    var url = Environment.API_ENDPOINT + '/api/orders';

    var response = await http.post(url, headers: header, body: _body);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      orderSaved = Order.fromJson(mapResponse['data']);
    } else {
      orderSaved = null;
    }
    if (orderSaved != null) print("orderSaved: " + orderSaved.toString());
    return orderSaved;
  }

  static Future<OrderList> getOrdersByUserdId(OrderList orderList) async {
    if (orderList == null) {
      orderList = new OrderList(new List<Order>(), null, false, -1);
    }
    if (orderList.isEndOfItems()) {
      return orderList;
    }
    var user = await Login.getUser();

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    String url = "";
    if (orderList.nextPageUrl == null || orderList.nextPageUrl.isEmpty) {
      url = Environment.API_ENDPOINT +
          '/api/orders?status=active&search=user_id:' +
          user.id.toString() +
          '&orderBy=id&sortedBy=desc&page=1&limit=' +
          Environment.PAGE_LIMIT.toString();
    } else {
      url = orderList.nextPageUrl;
    }
    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);

      List listaResponse = mapResponse['data']['data'];

      List<Order> list = List<Order>();

      for (Map map in listaResponse) {
        Order a = Order.fromJson(map);
        list.add(a);
      }

      orderList.orders.addAll(list);
      orderList.nextPageUrl = mapResponse['data']['next_page_url'];
      orderList.totalItems = mapResponse['data']['total'];
    }
    if (orderList != null) print("orderList: " + orderList.toString());
    return orderList;
  }

  static Future<List<OrderItem>> getOrderListsByOrderId(int orderId) async {
    var user = await Login.getUser();

    List<OrderItem> orderListByOrderId;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url = Environment.API_ENDPOINT +
        '/api/order_lists?search=user_id:' +
        user.id.toString() +
        '&search=order_id:' +
        orderId.toString();

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);

      List listaResponse = mapResponse['data'];

      orderListByOrderId = List<OrderItem>();

      for (Map map in listaResponse) {
        OrderItem a = OrderItem.fromJson(map);
        a.product = await ProductApi.getProductById(a.productId);
        if (a.product == null) {
          a.product = new Product(
              0, "Produto não encontrado", null, 0.00, null, null, 0);
        }
        orderListByOrderId.add(a);
      }
    } else {
      orderListByOrderId = null;
    }
    if (orderListByOrderId != null)
      print("orderListByOrderId: " + orderListByOrderId.toString());
    return orderListByOrderId;
  }

  static Future<FreightRequest> requestFreight(
      String state, String city, String neighborhood) async {
    var user = await Login.getUser();
    FreightRequest freightsRequest;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    Map params = {
      "user_id": user.id,
      "estado": state,
      "cidade": city,
      "bairro": neighborhood,
    };

    var _body = json.encode(params);

    var url = Environment.API_ENDPOINT + '/api/freight_requests';

    var response = await http.post(url, headers: header, body: _body);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      freightsRequest = FreightRequest.fromJson(mapResponse['data']);
    } else {
      freightsRequest = null;
    }
    if (freightsRequest != null)
      print("FreightsRequested: " + freightsRequest.toString());
    return freightsRequest;
  }

  static Future<bool> isAddressAvaliable(int addressId) async {
    var user = await Login.getUser();

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url = Environment.API_ENDPOINT +
        '/api/orders?search=address_id:' +
        addressId.toString() +
        '&user_id:' +
        user.id.toString();

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);

      List listaResponse = mapResponse['data'];

      return listaResponse.length > 0;
    }
    throw HttpException;
  }
}
