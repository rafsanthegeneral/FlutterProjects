import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/bmi.dart';

class InchiToCm extends StatefulWidget {
  @override
  _InchiToCmState createState() => _InchiToCmState();
}

class _InchiToCmState extends State<InchiToCm> {
  final feet_value = TextEditingController();
  double calculate;

  void _convert_meter() {
    calculate = double.tryParse(feet_value.text) * 0.3048;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inchi To Meter ",
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Convert Feet To Meter",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40),
              ),
              CustomTextField(
                customcontroller: feet_value,
                textname: "Enter your Feet Value",
                color: Colors.blueAccent,
              ),
              ElevatedButton(
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
                  if (feet_value.text == "") {
                    showDialog(
                        context: context,
                        builder: (BuildContext a) {
                          return AlertDialog(
                            title: Text(
                              "Fill Cannot be Empty",
                            ),
                          );
                        });
                  } else {
                    _convert_meter();
                    Clipboard.setData(
                        ClipboardData(text: "${calculate.toStringAsFixed(3)}"));
                    showDialog(
                      context: context,
                      builder: (BuildContext a) {
                        return AlertDialog(
                          title: Center(
                            child: Column(
                              children: [
                                Text("Data Auto copied !"),
                                Text(
                                  "${calculate.toStringAsFixed(3)}",
                                  style: TextStyle(
                                    fontSize: 80,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
