import 'package:shoppingmobile/datas/cart_item.dart';
import 'package:shoppingmobile/models/cart_model.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import 'package:shoppingmobile/widgets/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCart extends StatelessWidget {
  final CartItem cartItem;

  ProductCart(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(builder: (context, model, child) {
      return Card(
        elevation: 12,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: _buildContent(context)),
      );
    });
  }

  Widget _buildContent(BuildContext context) {
/*     if (cartItem.product == null) {
      return Container(child: Text(""));
    } */
    return ClipRRect(
      child: Row(children: <Widget>[
        Container(
          height: 80.0,
          width: 80.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(Environment.URL_IMAGE_PRODUCTS +
                    cartItem.product.image.toString()),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(35.0),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  cartItem.product.name,
                  style: foodNameText,
                ),
                SizedBox(height: 15.0),
                Text("R\$ ${cartItem.product.price.toStringAsFixed(2)}",
                    style: priceText),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(0),
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<CartModel>(context, listen: false)
                                .removeQuantity(cartItem);
                          },
                          child: Icon(
                            Icons.remove_circle_outline,
                            size: 30,
                          ),
                        )),
                    Text(
                      cartItem.quantity.toString(),
                      style: contrastTextBold,
                    ),
                    Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(0),
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<CartModel>(context, listen: false)
                                .addQuantity(cartItem);
                          },
                          child: Icon(
                            Icons.add_circle_outline,
                            size: 30,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: _buildChild(),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<CartModel>(context, listen: false)
                          .removeCartItem(cartItem);
                    },
                    child: Icon(
                      Icons.delete,
                      size: 25.0,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _buildChild() {
    if (cartItem.details == "") {
      return null;
    }
    return Container(
        width: 210,
        child: Text(
          "Observações: \n${cartItem.details}",
          style: detailsStyle,
          textDirection: TextDirection.ltr,
        ));
  }
}
