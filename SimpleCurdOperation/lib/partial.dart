import 'package:flutter/material.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatefulWidget {
  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      title: "hello World",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int data_val = 0;
  String webhost;
  bool pressGeoON = false;
  bool cmbscritta = false;
  void work() {
    setState(() {
      data_val += 1;
    });
  }

  void back() {
    setState(() {
      data_val -= 1;
    });
  }

  void clean() {
    setState(() {
      data_val = 0;
    });
  }

  void load() {
    webhost = "motherchod";
  }

  void call() {
    setState(() {
      pressGeoON = !pressGeoON;
      cmbscritta = !cmbscritta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is Educational perpose  "),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "$data_val",
              style: TextStyle(
                fontSize: 23.4,
                fontFamily: "airal",
                color: Colors.green,
              ),
            ),
            // RaisedButton(onPressed:work,
            //   child: Text(
            //     "click to change "
            //   ),
            //   color: Colors.green,
            // ),
            // RaisedButton(onPressed: back,
            //  child: Text(
            //    "backspace"
            //  ),
            //  color: Colors.grey,
            // ),
            // RaisedButton(onPressed:clean,
            //    child: Text(
            //      "clean",
            //    ),
            //    color: Colors.red,
            // ),
            // RaisedButton(onPressed:call,
            //    child: cmbscritta ? Text("fuckoff") : Text(""),
            //    color: Colors.green,
            // )
          ],
        ),
      ),
    );
  }
}
