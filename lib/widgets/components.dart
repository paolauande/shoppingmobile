import 'package:shoppingmobile/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:shoppingmobile/datas/products.dart';
import 'package:shoppingmobile/widgets/config.dart';
import '../widgets/colors.dart';
import '../widgets/styles.dart';

FlatButton myFlatBtn(String text, onPressed) {
  return FlatButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: whiteText,
    ),
    textColor: white,
    color: highlightColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(15))),
  );
}

appBar() {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.black),
    centerTitle: true,
    automaticallyImplyLeading: false,
    elevation: 0,
    backgroundColor: highlightColor,
    title: Column(
      children: <Widget>[
        Image.asset(
          "images/logo.png",
          fit: BoxFit.cover,
          height: 45,
        ),
      ],
    ),
  );
}

Widget foodItem(Product product,
    {double imgWidth, onTapped, bool isProductPage = false}) {
  return Container(
    padding: EdgeInsets.all(5),
    height: 300,
    margin: EdgeInsets.only(left: 20),
    child: Stack(
      children: <Widget>[
        SizedBox(
            height: 200,
            child: RaisedButton(
                padding: EdgeInsets.all(10),
                color: highlightColor.withOpacity(0.5),
                elevation: (isProductPage) ? 9 : 15,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: onTapped,
                child: Hero(
                    transitionOnUserGestures: true,
                    tag: new Text("hero1"),
                    child: Image.network(
                      Environment.URL_IMAGE_PRODUCTS + product.image.toString(),
                      width: (imgWidth != null) ? imgWidth : 180,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    )))),
        Positioned(
          bottom: 20,
          left: 5,
          child: (!isProductPage)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(product.name, style: foodNameText),
                    Text("R\$ ${product.price.toStringAsFixed(2)}",
                        style: priceText),
                  ],
                )
              : Text(' '),
        )
      ],
    ),
  );
}
