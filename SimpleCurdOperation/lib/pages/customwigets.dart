import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  CustomTextFiled(
      {Key key,
      this.name,
      this.textcontroller,
      this.validatorfunction,
      this.initvalue,
      this.secureText,
      this.onchange})
      : super(key: key);
  String name;
  TextEditingController textcontroller;
  Function validatorfunction;
  String initvalue;
  bool secureText;
  Function onchange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      initialValue: initvalue,
      obscureText: secureText,
      onChanged: onchange,
      decoration: InputDecoration(
        labelText: name,
        labelStyle: TextStyle(fontSize: 20),
        border: OutlineInputBorder(),
        errorStyle: TextStyle(color: Colors.red),
      ),
      controller: textcontroller,
      validator: validatorfunction,
    );
  }
}
