import 'package:shoppingmobile/models/cart_model.dart';
import 'package:shoppingmobile/models/login.dart';
import 'package:shoppingmobile/widgets/colors.dart';
import 'package:shoppingmobile/widgets/productCart.dart';
import 'package:shoppingmobile/widgets/priceCart.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmobile/widgets/components.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    checkUserSession();
  }

  checkUserSession() async {
    bool isTokenExpired = await Login.isTokenExpired();
    if (isTokenExpired) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(),
      body: Consumer<CartModel>(builder: (context, model, child) {
        if (model.cartList == null || model.cartList.length == 0) {
          return Center(
            child: Text(
              "Nenhum produto no carrinho!",
              style: alertText,
            ),
          );
        } else
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //sectionHeader('Meu Carrinho', onViewMore: () {}),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  scrollDirection: Axis.vertical,
                  itemCount: model.cartList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ProductCart(model.cartList[index]),
                      ],
                    );
                  },
                ),
                PriceCart()
              ],
            ),
          );
      }),
    );
  }
}
