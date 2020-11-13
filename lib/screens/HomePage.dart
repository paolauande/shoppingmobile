import 'package:flutter/material.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import '../widgets/colors.dart';
import '../widgets/components.dart';

import 'package:page_transition/page_transition.dart';
import './SignUpPage.dart';
import './LoginPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    //checkUserSession();
  }

/*   checkUserSession() async {
    bool isTokenExpired = await Login.isTokenExpired();
    if (isTokenExpired) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Seja bem-vindo",
            style: h3,
          ),
          SizedBox(
            height: 20,
          ),
          Image.asset('images/logo.png', width: 190, height: 190),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 200,
            margin: EdgeInsets.only(bottom: 0),
            child: myFlatBtn('Entrar', () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rotate,
                      duration: Duration(seconds: 1),
                      child: LoginPage()));
            }),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.all(0),
            child: myFlatBtn('Criar conta', () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rotate,
                      duration: Duration(seconds: 1),
                      child: SignUpPage()));
            }),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          )
        ],
      )),
      backgroundColor: bgColor,
    );
  }
}
