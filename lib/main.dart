import 'package:shoppingmobile/models/cart_model.dart';
import 'package:shoppingmobile/screens/BottomNavigationBarPage.dart';
import 'package:shoppingmobile/screens/SplashScreen.dart';
import 'package:shoppingmobile/screens/StorePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmobile/widgets/colors.dart';
import './screens/LoginPage.dart';
import './screens/SignUpPage.dart';
import './screens/HomePage.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartModel>(
      create: (context) => CartModel(),
      child: MaterialApp(
        title: 'Shopping Mobile',
        theme: ThemeData(
          primaryColor: highlightColor,
        ),
        home: Splash(),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(),
          '/signup': (BuildContext context) => SignUpPage(),
          '/login': (BuildContext context) => LoginPage(),
          '/store': (BuildContext context) => StorePage(),
          '/appbar': (BuildContext context) => BottomNavigatioBarPage()
        },
      ),
    );
  }
}
