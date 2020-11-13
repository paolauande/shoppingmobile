import 'package:shoppingmobile/models/cart_model.dart';
import 'package:shoppingmobile/screens/CartPage.dart';
import 'package:shoppingmobile/screens/MyOrdersPage.dart';
import 'package:shoppingmobile/screens/ProfilePage.dart';
import 'package:shoppingmobile/screens/StorePage.dart';
import 'package:shoppingmobile/widgets/colors.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigatioBarPage extends StatefulWidget {
  @override
  _BottomNavigatioBarPageState createState() => _BottomNavigatioBarPageState();
}

class _BottomNavigatioBarPageState extends State<BottomNavigatioBarPage> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    StorePage(),
    CartPage(),
    MyOrders(),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: Consumer<CartModel>(
        builder: (context, model, child) {
          return BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.shop),
                  title: Text(
                    'Loja',
                    style: tabLinkStyle,
                  )),
              BottomNavigationBarItem(
                  icon: new Stack(children: <Widget>[
                    Icon(Icons.shopping_cart),
                    model.cartList != null && model.cartList.length != 0
                        ? new Positioned(
                            right: 0,
                            child: new Container(
                              padding: EdgeInsets.all(1),
                              decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6)),
                              constraints:
                                  BoxConstraints(minWidth: 12, minHeight: 12),
                              child: new Text(
                                '${model.cartList.length.toString()}',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 8),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : new Text("")
                  ]),
                  title: Text(
                    'Carrinho',
                    style: tabLinkStyle,
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  title: Text(
                    'Pedidos',
                    style: tabLinkStyle,
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text(
                    'Perfil',
                    style: tabLinkStyle,
                  )),
            ],
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            fixedColor: highlightColor,
            onTap: _onItemTapped,
          );
        },
      ),
    );
  }
}
