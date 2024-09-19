import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_app/about.dart';
import 'package:test_app/inchitocm.dart';

class Practice extends StatefulWidget {
  @override
  _PracticeState createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  final hight = TextEditingController();

  final weight = TextEditingController();
  double calculate;
  String result;
  Color color;

  void _calculate() {
    setState(
      () {
        if (hight.text != "" && weight.text != "") {
          calculate = double.tryParse(weight.text) /
              (double.tryParse(hight.text) * double.tryParse(hight.text));

          if (calculate < 18.5) {
            result = "LOW";
            color = Colors.amber;
          } else if (calculate < 25.0) {
            result = "GOOD";
            color = Colors.green;
          } else if (calculate < 30.0) {
            result = "BAD";
            color = Colors.redAccent;
          } else {
            result = "Very BAD";
            color = Colors.red;
          }
        } else {
          hight.text = "";
          weight.text = "";
          result = "0";
          color = Colors.red;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "What is your BMI index",
            style: TextStyle(),
          ),
        ),
      ),
      body: Container(
          child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "BMI Looks UP",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
            customcontroller: weight,
            textname: "Enter your Weight",
            color: Color.fromARGB(255, 221, 218, 9),
          ),
          CustomTextField(
            customcontroller: hight,
            textname: "Enter your Hight in Meter",
            color: Colors.indigo,
          ),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              child: Text(
                "See Result ",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
              onPressed: () {
                _calculate();
                if (hight.text == "" && weight.text == "") {
                  showDialog(
                    context: context,
                    builder: (BuildContext a) {
                      return AlertDialog(
                          title: Text("Please Fill Up All information"));
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext a) {
                      return AlertDialog(
                          title: Center(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child: Text(
                                "YOUR BMI INDEX",
                                style: TextStyle(
                                  color: Colors.cyan,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Text(
                                "${calculate.toStringAsFixed(5)}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Text(
                                "BMI Serverity is ${result}",
                                style: TextStyle(
                                  color: color,
                                ),
                              ),
                            )
                          ],
                        ),
                      ));
                    },
                  );
                }
              },
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InchiToCm()),
              );
            },
            child: Text(
              "Click Convert Feet to Meter",
              style: TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => About()),
              );
            },
            child: Text(
              "About Developer",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          )
        ],
      )),
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.textname,
    this.color,
    this.customcontroller,
  });

  final String textname;
  final Color color;
  TextEditingController customcontroller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: customcontroller,
        decoration: new InputDecoration(
          labelText: textname,
          fillColor: color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(),
          ),
          //fillColor: Colors.green
        ),
        validator: (val) {
          if (val.length == 0) {
            return "Field cannot be empty";
          } else {
            return null;
          }
        },
        textAlign: TextAlign.center,
      ),
    );
  }
}

// class TestCustomeTextField extends StatefulWidget {
//   @override
//   _TestCustomeTextFieldState createState() => _TestCustomeTextFieldState();
// }

// class _TestCustomeTextFieldState extends State<TestCustomeTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(11.0),
//       child: TextFormField(
//         keyboardType: TextInputType.number,
//         controller: customcontroller,
//         decoration: new InputDecoration(
//           labelText: textname,
//           fillColor: color,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide(),
//           ),
//           //fillColor: Colors.green
//         ),
//         validator: (val) {
//           if (val.length == 0) {
//             return "Field cannot be empty";
//           } else {
//             return null;
//           }
//         },
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }

