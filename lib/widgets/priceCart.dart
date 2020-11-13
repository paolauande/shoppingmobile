import 'package:shoppingmobile/datas/address.dart';
import 'package:shoppingmobile/datas/order.dart';
import 'package:shoppingmobile/datas/payment.dart';
import 'package:shoppingmobile/models/cart_model.dart';
import 'package:shoppingmobile/screens/BottomNavigationBarPage.dart';
import 'package:shoppingmobile/services/address_api.dart';
import 'package:shoppingmobile/services/orders_api.dart';
import 'package:shoppingmobile/widgets/components.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceCart extends StatefulWidget {
  @override
  _PriceCartState createState() => _PriceCartState();
}

class _PriceCartState extends State<PriceCart> {
  Future _getPayments;
  Future _getUserAddresses;

  @override
  void initState() {
    super.initState();
    _getPayments = OrdersApi.getPayments();
    _getUserAddresses = AddressApi.getUserAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Consumer<CartModel>(
        builder: (context, model, child) {
          return Column(
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                  Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        FutureBuilder<List<Address>>(
                          future: _getUserAddresses,
                          builder:
                              (context, AsyncSnapshot<List<Address>> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text(""),
                              );
                            } else {
                              return DropdownButton<Address>(
                                items: snapshot.data
                                    .map((Address address) =>
                                        new DropdownMenuItem<Address>(
                                          child: _buildSelector(address),
                                          value: address,
                                        ))
                                    .toList(),
                                onChanged: (Address value) {
                                  Provider.of<CartModel>(context, listen: false)
                                      .setAddress(value);
                                },
                                isExpanded: true,
                                hint: Text("Endereço", style: subtotalText),
                                disabledHint: Text(
                                  "Adicione endereço em Perfil",
                                  style: alertText,
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        model.address != null ? _buildAddress(model) : Text("")
                      ],
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Text("Taxa de entrega", style: subtotalText),
                            model.freight != null
                                ? Text(
                                    "${model.freight.name} - R\$ ${model.freight.value.toStringAsFixed(2)}",
                                    style: totalText)
                                : Text("")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Subtotal", style: subtotalText),
                  model.getSubTotal() != null
                      ? Text("R\$ ${model.getSubTotal().toStringAsFixed(2)}",
                          style: totalText)
                      : Text("")
                ],
              ),
              Divider(
                height: 20,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total", style: totalText),
                  Text("R\$ ${(model.getTotal()).toStringAsFixed(2)}",
                      style: totalText),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      FutureBuilder<List<Payment>>(
                        future: _getPayments,
                        builder:
                            (context, AsyncSnapshot<List<Payment>> snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return DropdownButton<Payment>(
                            items: snapshot.data
                                .map((pay) => DropdownMenuItem<Payment>(
                                      child: Text(
                                        pay.name,
                                        style: totalText,
                                      ),
                                      value: pay,
                                    ))
                                .toList(),
                            onChanged: (Payment value) {
                              Provider.of<CartModel>(context, listen: false)
                                  .setPayment(value);
                            },
                            isExpanded: false,
                            hint:
                                Text("Forma de pagamento", style: paymentText),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      model.payment != null
                          ? Text(model.payment.name, style: totalText)
                          : Text("")
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: myFlatBtn("Finalizar Pedido", () async {
                  if (!model.isValid()) {
                    return showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Complete os campos',
                            style: priceText,
                          ),
                          content: Text(
                            model.getRequiredField(),
                            textAlign: TextAlign.justify,
                            style: h6,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'ok',
                                style: priceText,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  Order toSave = model.getOrder();
                  Order orderSaved = await OrdersApi.checkout(toSave);
                  if (orderSaved != null) {
                    for (var orderItem in toSave.orderList) {
                      OrdersApi.saveItem(orderItem, orderSaved.id);
                    }
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BottomNavigatioBarPage()),
                        ModalRoute.withName('/'));

                    showCheckoutDialog();
                  }
                  model.reset();
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  showCheckoutDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pedido Realizado',
            style: priceText,
          ),
          content: const Text(
            'Seu pedido foi computado com sucesso!',
            style: h6,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'ok',
                style: priceText,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelector(Address address) {
    if (address.complement == "") {
      return Text(
          "${address.street}, ${address.number.toString()}, ${address.neighborhood}, ${address.cep.toString()}",
          style: totalText,
          textAlign: TextAlign.center);
    } else
      return Text(
        "${address.street}, ${address.number.toString()}, ${address.complement}, ${address.neighborhood}, ${address.cep.toString()}",
        style: totalText,
        textAlign: TextAlign.center,
      );
  }

  Widget _buildAddress(CartModel model) {
    if (model.address.complement == "") {
      return Text(
          "${model.address.street}, Nº${model.address.number.toString()}\n${model.address.neighborhood}\n${model.address.cep.toString()}",
          style: totalText,
          textAlign: TextAlign.center);
    } else
      return Text(
        "${model.address.street}, Nº${model.address.number.toString()}\n${model.address.complement}\n${model.address.neighborhood}\n${model.address.cep.toString()}",
        style: totalText,
        textAlign: TextAlign.center,
      );
  }
}
