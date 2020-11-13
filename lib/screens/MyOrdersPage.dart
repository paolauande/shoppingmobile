import 'package:shoppingmobile/datas/order.dart';
import 'package:shoppingmobile/datas/orderList.dart';
import 'package:shoppingmobile/models/login.dart';
import 'package:shoppingmobile/services/orders_api.dart';
import 'package:shoppingmobile/widgets/colors.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmobile/widgets/components.dart';

class MyOrders extends StatelessWidget {
  OrderList _orderList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: appBar(),
        body: FutureBuilder<OrderList>(
            future: OrdersApi.getOrdersByUserdId(_orderList),
            builder: (context, snapshots) {
              if (snapshots.hasError) return Text("Error Occurred");
              switch (snapshots.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (!snapshots.hasData ||
                      snapshots.data.orders == null ||
                      snapshots.data.orders.isEmpty) {
                    return Center(
                      child: Text(
                        "Você ainda não fez nenhum pedido!",
                        style: alertText,
                      ),
                    );
                  } else {
                    return MyOrdersList(snapshots.data);
                  }
              }
            }));
  }
}

class MyOrdersList extends StatefulWidget {
  final OrderList _orderList;
  MyOrdersList(this._orderList);

  @override
  _MyOrdersListState createState() => _MyOrdersListState(this._orderList);
}

class _MyOrdersListState extends State<MyOrdersList> {
  OrderList _orderList;
  _MyOrdersListState(this._orderList);
  String message = "";
  ScrollController _scrollController = new ScrollController();

  void _getMoreData() async {
    if (!_orderList.isLoading) {
      setState(() {
        _orderList.isLoading = true;
      });

      OrdersApi.getOrdersByUserdId(_orderList).then((onValue) {
        setState(() {
          _orderList.isLoading = false;
          _orderList = onValue;
        });
      });
    }
  }

  @override
  void initState() {
    checkUserSession();
    this._getMoreData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          message = "Não há mais pedidos";
        });
      }
    });
  }

  checkUserSession() async {
    bool isTokenExpired = await Login.isTokenExpired();
    if (isTokenExpired) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Widget _buildProgressIndicator(bool isLoading) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildList());
  }

  Widget _buildList() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _orderList.orders.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == _orderList.orders.length) {
                return _buildProgressIndicator(_orderList.isLoading);
              } else {
                return Container(
                    child: _buildOrderCard(_orderList.orders[index]));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      elevation: 9,
      margin: EdgeInsets.all(10),
      child: new Container(
          margin: EdgeInsets.only(right: 18),
          child: new Center(
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                      padding: EdgeInsets.all(15.0),
                      child: ExpansionTile(
                        leading: Icon(Icons.fastfood),
                        title: new Row(children: <Widget>[
                          Flexible(
                              child: Text(
                            "Pedido: ",
                            style: h6,
                          )),
                          Flexible(
                            child: Text("${order.id.toString()}",
                                style: productsOrder),
                          )
                        ]),
                        subtitle: new Row(children: <Widget>[
                          Flexible(
                              child: _buildStatus(
                            order.orderStatus,
                          ))
                        ]),
                        children: <Widget>[
                          Text(
                            "Descrição: ",
                            style: h6,
                          ),
                          _buildOrderItemCard(order.id),
                          SizedBox(
                            height: 10,
                          ),
                          new Row(children: <Widget>[
                            Flexible(
                                child: Text(
                              "Subtotal: ",
                              style: h6,
                            )),
                            Flexible(
                              child: Text(
                                  "R\$${(order.totalAmount - order.delivery).toStringAsFixed(2)}",
                                  style: priceOrder),
                            )
                          ]),
                          new Row(children: <Widget>[
                            Flexible(
                                child: Text(
                              "Taxa de entrega: ",
                              style: h6,
                            )),
                            Flexible(
                              child: Text(
                                  "R\$${order.delivery.toStringAsFixed(2)}",
                                  style: priceOrder),
                            )
                          ]),
                          new Row(children: <Widget>[
                            Flexible(
                                child: Text(
                              "Total: ",
                              style: h6,
                            )),
                            Flexible(
                              child: Text(
                                  "R\$${order.totalAmount.toStringAsFixed(2)}",
                                  style: priceOrder),
                            )
                          ])
                        ],
                      )),
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
    );
  }

  Widget _buildOrderItemCard(int orderId) {
    return Container(
      child: FutureBuilder<List<OrderItem>>(
        future: OrdersApi.getOrderListsByOrderId(orderId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Center(child: Text("Sem conexão", style: alertText));
            case ConnectionState.waiting:
              return new Center(child: Text("Aguardando...", style: alertText));
            default:
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          _buildProductsText(
                            snapshot.data[index],
                          ),
                          style: productsOrder,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                );
              } else {
                return new Center(
                  child: Text(
                    "Sem dados",
                    style: alertText,
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget _buildStatus(String status) {
    Widget child;
    if (status == "pending") {
      child = Text(
        "Pendente",
        style: pending,
      );
    } else if (status == "preparing") {
      child = Text(
        "Preparando",
        style: preparing,
      );
    } else if (status == "in_transport") {
      child = Text(
        "À caminho",
        style: inTransport,
      );
    } else if (status == "delivered") {
      child = Text(
        "Entregue",
        style: delivered,
      );
    } else if (status == "excluded") {
      child = Text(
        "Excluído",
        style: alertText,
      );
    }
    return Container(
      child: child,
    );
  }

  String _buildProductsText(OrderItem orderItem) {
    int amount = orderItem.amount;
    String name = orderItem.product.name;

    String text = "$amount x $name";
    return text;
  }
}
