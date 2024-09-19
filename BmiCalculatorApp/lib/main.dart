import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:test_app/bmi.dart';

void main() {
  runApp(homeApp());
}

class homeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "home2",
      debugShowCheckedModeBanner: false,
      home: Practice(),
    );
  }
}

class Rafsan extends StatefulWidget {
  @override
  _RafsanState createState() => _RafsanState();
}

class _RafsanState extends State<Rafsan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World"),
        elevation: 8,
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child:
                        Image.asset("images/google.png", height: 60, width: 60),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("Sing in With Google",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              onPressed: () {},
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              child: Text("Sing in With facebook",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                print("Hello world");
              },
              color: Colors.blue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
                child: Text("Sing in With Git hub",
                    style: TextStyle(color: Colors.black)),
                onPressed: () {},
                color: Colors.yellow),
          ),
        ],
      )),
    );
  }
}

class CustomButton extends StatelessWidget {
  // custom raised button Word
  CustomButton({
    this.child,
    this.color,
    this.borderRadius,
    this.onPressed,
  });

  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
    );
  }
}
