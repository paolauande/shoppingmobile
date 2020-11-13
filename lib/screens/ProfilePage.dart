import 'package:shoppingmobile/models/login.dart';
import 'package:shoppingmobile/screens/Addresses.dart';
import 'package:shoppingmobile/screens/UserData.dart';
import 'package:shoppingmobile/widgets/colors.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shoppingmobile/widgets/components.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
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
    return new Scaffold(
        backgroundColor: bgColor,
        appBar: appBar(),
        body: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: bgColor,
            title: Text(
              "",
              style: h4,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              new Container(
                margin: EdgeInsets.only(right: 25),
                child: _signOut(),
              ),
            ],
          ),
          body: Column(children: <Widget>[
            Expanded(
              child: Column(children: <Widget>[
                Center(child: UserData()),
                Expanded(child: Addresses()),
              ]),
            ),
          ]),
        ));
  }

  Widget _signOut() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 20.0,
        child: new Text(
          "sair",
          style: h6,
        ),
      ),
      onTap: () {
        _logoutBtn(context);
      },
    );
  }

  _logoutBtn(BuildContext context) async {
    showDialog(
        context: context,
        child: new AlertDialog(
          title: Text(
            "Deseja sair do app?",
            style: alertText,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: h6,
              ),
            ),
            FlatButton(
              onPressed: () {
                Login.remove();
                new Future.delayed(const Duration(seconds: 2));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', (Route<dynamic> route) => false);
              },
              child: Text(
                "Sair",
                style: h6,
              ),
            )
          ],
        ));
  }
}
