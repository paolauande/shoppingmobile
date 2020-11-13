import 'package:shoppingmobile/widgets/styles.dart';
import 'package:flutter/material.dart';

alert(BuildContext context, String msg) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ops!", style: h6),
          content: Text(msg, style: alertText),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  "Ok",
                  style: h6,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      });
}
