import 'dart:async';
import 'package:shoppingmobile/models/login.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmobile/widgets/colors.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String newRoute;
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(newRoute);
  }

  @override
  void initState() {
    super.initState();
    checkUserSession();
    startTime();
  }

  checkUserSession() async {
    Login.isTokenExpired().then((onValue) {
      return setState(() {
        newRoute = onValue ? '/home' : '/appbar';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: highlightColor,
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          child: new Image.asset("images/logo.png", width: 190, height: 190),
        ),
      ),
    );
  }
}
