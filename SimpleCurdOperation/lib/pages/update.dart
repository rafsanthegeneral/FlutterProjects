import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_app/pages/customwigets.dart';

class Update extends StatefulWidget {
  Update({this.id});
  final String id;

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final _formKey = GlobalKey<FormState>();
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

  CollectionReference students =
      FirebaseFirestore.instance.collection('Students');

  Future<void> update(id, name, email, password) {
    return students
        .doc(id)
        .update({'name': name, 'email': email, 'password': password})
        .then((value) => print("user Update"))
        .catchError((value) {
          print("$value for not Happned");
        });
  }

  clearText() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Student Page "),
      ),
      body: Form(
        key: _formKey,
        //Getting data from id
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('Students')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print("Some Thing Went Wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var data = snapshot.data.data();
              var name = data['name'];
              var email = data['email'];
              var password = data['password'];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomTextFiled(
                        name: "Name",
                        secureText: false,
                        onchange: (value) {
                          name = value;
                        },
                        textcontroller: nameController,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomTextFiled(
                        name: "Email",
                        secureText: false,
                        onchange: (value) {
                          email = value;
                        },
                        textcontroller: emailController,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomTextFiled(
                        name: "password",
                        secureText: true,
                        onchange: (value) {
                          password = value;
                        },
                        textcontroller: passwordController,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            child: Text(
                              "Update",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                update(widget.id, name, email, password);
                                Navigator.pop(context);
                              }
                            },
                          ),
                          ElevatedButton(
                            child: Text(
                              "Reset",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            onPressed: () {
                              clearText();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
