import 'package:shoppingmobile/datas/cart_item.dart';
import 'package:shoppingmobile/datas/products.dart';
import 'package:shoppingmobile/models/cart_model.dart';
import 'package:shoppingmobile/widgets/inputFields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';
import '../widgets/styles.dart';
import '../widgets/colors.dart';
import '../widgets/components.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  ProductPage({Key key, this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState(product);
}

class _ProductPageState extends State<ProductPage> {
  final Product product;
  _ProductPageState(this.product);
  int quantity = 1;

  TextEditingController _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _detailsController.text;
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: bgColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: bgColor,
            centerTitle: true,
            leading: BackButton(
              color: dark,
            ),
            title: Text(widget.product.name, style: h4),
          ),
          body: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(top: 100, bottom: 100),
                          padding: EdgeInsets.only(top: 100, bottom: 50),
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(widget.product.name, style: h5),
                              Text(
                                  "R\$${widget.product.price.toStringAsFixed(2)}",
                                  style: priceText),
                              Text(
                                widget.product.description,
                                style: h6,
                                textAlign: TextAlign.center,
                              ),
                              product.preparation == "0"
                                  ? Text("")
                                  : Text(
                                      "Preparo: ${widget.product.preparation} minutos",
                                      style: h6,
                                      textAlign: TextAlign.center,
                                    ),
                              SizedBox(height: 15),
                              Container(
                                  width: 300,
                                  child: detailsInput(
                                      "adicione alguma observação",
                                      controller: _detailsController)),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 25),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text('Quantidade', style: h6),
                                      margin: EdgeInsets.only(bottom: 15),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 55,
                                          height: 55,
                                          child: Icon(
                                            Icons.remove_circle_outline,
                                            size: 40,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(quantity.toString(),
                                              style: h3),
                                        ),
                                        Container(
                                          width: 55,
                                          height: 55,
                                          child: Icon(
                                            Icons.add_circle_outline,
                                            size: 40,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20.0),
                                  ],
                                ),
                              ),
                              Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: 220,
                                    child: myFlatBtn('Adicionar ao carrinho',
                                        () async {
                                      CartItem cartItem = CartItem(product,
                                          quantity, _detailsController.text);

                                      Provider.of<CartModel>(context,
                                              listen: false)
                                          .addToCart(cartItem);

                                      showDialog(
                                          context: context,
                                          child: new AlertDialog(
                                            title: Text(
                                              "Adicionado ao carrinho!",
                                              style: alertText,
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () {
                                                  int count = 0;
                                                  Navigator.of(context)
                                                      .popUntil(
                                                          (_) => count++ >= 2);
                                                },
                                                child: Text(
                                                  "ok",
                                                  style: h6,
                                                ),
                                              ),
                                            ],
                                          ));
                                    }),
                                  );
                                },
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                    color: Color.fromRGBO(0, 0, 0, .05))
                              ]),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 200,
                          height: 160,
                          child: foodItem(
                            widget.product,
                            isProductPage: true,
                            onTapped: () {},
                            imgWidth: 250,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
