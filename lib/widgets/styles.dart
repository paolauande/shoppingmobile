import 'package:flutter/material.dart';
import './colors.dart';

//text styles

const whiteText = TextStyle(color: Colors.white, fontFamily: 'Poppins');
const disabledText = TextStyle(color: Colors.grey, fontFamily: 'Poppins');
const contrastText = TextStyle(color: highlightColor, fontFamily: 'Poppins');
const contrastTextBold = TextStyle(
    color: highlightColor, fontFamily: 'Poppins', fontWeight: FontWeight.w800);

const h3 = TextStyle(
    color: Colors.black,
    fontSize: 24,
    letterSpacing: 3,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins');

const z4 = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const h4 = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const g4 = TextStyle(
    color: Colors.grey,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const h5 = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins');

const h6 = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins');

const productsOrder = TextStyle(
    color: highlightColor,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Poppins');

const pending = TextStyle(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins');

const preparing = TextStyle(
    color: Colors.yellow,
    fontSize: 14,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins');

const inTransport = TextStyle(
    color: Colors.blue,
    fontSize: 14,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins');

const delivered = TextStyle(
    color: Colors.green,
    fontSize: 14,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins');

const detailsStyle = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    fontFamily: 'Poppins');

const alertText = TextStyle(
    color: Colors.red,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins');

const inkText = TextStyle(
    color: Colors.red,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins');

const priceText = TextStyle(
    color: highlightColor,
    fontSize: 12,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins');

const totalText = TextStyle(
    color: Color(0xff444444),
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const priceOrder = TextStyle(
    color: Color(0xff444444),
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const subtotalText = TextStyle(
    color: Colors.grey, fontWeight: FontWeight.w700, fontFamily: 'Poppins');

const paymentText = TextStyle(
    color: highlightColor,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const foodNameText = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins');

const detailsText = TextStyle(
    color: highlightColor,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const editarText = TextStyle(
    color: highlightColor,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const usernameText = TextStyle(
    color: highlightColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins');

const cepText = TextStyle(
    color: highlightColor,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    fontFamily: 'Poppins');

const tabLinkStyle =
    TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins');

const taglineText = TextStyle(color: Colors.grey, fontFamily: 'Poppins');
const categoryText = TextStyle(
    color: Color(0xff444444),
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const inputFieldTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    color: Color(0xff444444));

const detailsTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Color(0xff444444));

const inputFieldHintTextStyle = TextStyle(fontFamily: 'Poppins');

const inputFieldPasswordTextStyle = TextStyle(
    fontFamily: 'Poppins', fontWeight: FontWeight.w500, letterSpacing: 3);

const inputFieldHintPaswordTextStyle = TextStyle(
    fontFamily: 'Poppins', color: Color(0xff444444), letterSpacing: 2);

//box decoration styles

const authPlateDecoration = BoxDecoration(
    color: white,
    boxShadow: [
      BoxShadow(
          color: Color.fromRGBO(0, 0, 0, .1),
          blurRadius: 10,
          spreadRadius: 5,
          offset: Offset(0, 1))
    ],
    borderRadius: BorderRadiusDirectional.only(
        bottomEnd: Radius.circular(20), bottomStart: Radius.circular(20)));

//input field styles
const inputFieldFocusedBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(5),
        topLeft: Radius.circular(15),
        topRight: Radius.circular(5),
        bottomRight: Radius.circular(15)),
    borderSide: BorderSide(
      color: highlightColor,
    ));

const inputFieldDefaultBorderStyle = OutlineInputBorder(
    gapPadding: 0,
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(5),
        topLeft: Radius.circular(15),
        topRight: Radius.circular(5),
        bottomRight: Radius.circular(15)));

const inputDetailsBorderStyle = OutlineInputBorder(
    gapPadding: 0, borderRadius: BorderRadius.all(Radius.circular(10)));
