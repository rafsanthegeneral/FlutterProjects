import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/pages/customwigets.dart';
import 'package:test_app/pages/gui.dart';

class Adding extends StatefulWidget {
  @override
  _AddingState createState() => _AddingState();
}

class _AddingState extends State<Adding> {
  final _formKey = GlobalKey<FormState>();
  var name = "";
  var email = "";
  var password = "";
  final nameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  clearText() {
    print(name);
    print(email);
    print(password);
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  CollectionReference students =
      FirebaseFirestore.instance.collection('Students');

  Future<void> addUser() {
    return students.add({'name': name, 'email': email, 'password': password});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Added a Student "),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextFiled(
                    name: "Name",
                    secureText: false,
                    textcontroller: nameController,
                    validatorfunction: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Name";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextFiled(
                    name: "Email",
                    secureText: false,
                    textcontroller: emailController,
                    validatorfunction: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter  Email";
                      } else if (!value.contains('@')) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextFiled(
                    name: "password",
                    secureText: true,
                    textcontroller: passwordController,
                    validatorfunction: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter  Email";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        name = nameController.text;
                        email = emailController.text;
                        password = passwordController.text;
                        clearText();
                        addUser();
                        Navigator.pop(context);
                      }
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}
