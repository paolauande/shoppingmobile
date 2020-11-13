import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import './colors.dart';
import './styles.dart';

Container textInput(String hintText,
    {onTap,
    onChanged,
    onEditingComplete,
    onSubmitted,
    TextEditingController controller,
    FormFieldValidator<String> validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      controller: controller,
      validator: validator,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      //onSubmitted: onSubmitted,
      cursorColor: highlightColor,
      style: inputFieldTextStyle,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}

Container emailInput(String hintText,
    {onTap,
    onChanged,
    onEditingComplete,
    onSubmitted,
    TextEditingController controller,
    FormFieldValidator<String> validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      controller: controller,
      validator: validator,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      //onSubmitted: onSubmitted,
      keyboardType: TextInputType.emailAddress,
      cursorColor: highlightColor,
      style: inputFieldTextStyle,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}

Container passwordInput(String hintText,
    {onTap,
    onChanged,
    onEditingComplete,
    onSubmitted,
    onPressed,
    obscureText,
    TextEditingController controller,
    FormFieldValidator<String> validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      //onSubmitted: onSubmitted,
      obscureText: obscureText,
      cursorColor: highlightColor,
      style: inputFieldTextStyle,
      decoration: InputDecoration(
          suffixIcon: new IconButton(
              icon: Icon(Icons.remove_red_eye), onPressed: onPressed),
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}

Container numberInput(String hintText,
    {onTap,
    onChanged,
    onEditingComplete,
    onSubmitted,
    TextEditingController controller,
    FormFieldValidator<String> validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      controller: controller,
      validator: validator,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      //onSubmitted: onSubmitted,
      keyboardType: TextInputType.number,
      maxLength: 11,
      cursorColor: highlightColor,
      style: inputFieldTextStyle,
      decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}

Container detailsInput(String hintText,
    {onTap, onChanged, onEditingComplete, TextEditingController controller}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      cursorColor: highlightColor,
      style: detailsTextStyle,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 6,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}

Container cpfInput(String hintText,
    {onTap,
    onChanged,
    onEditingComplete,
    onSubmitted,
    TextEditingController controller,
    FormFieldValidator<String> validator}) {
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      controller: controller,
      validator: validator,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      //onSubmitted: onSubmitted,
      keyboardType: TextInputType.number,
      inputFormatters: [maskTextInputFormatter],
      maxLength: 14,
      cursorColor: highlightColor,
      style: inputFieldTextStyle,
      decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}
