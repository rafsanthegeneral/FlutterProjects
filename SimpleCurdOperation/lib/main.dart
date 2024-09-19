import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(homeApp());
}

class homeApp extends StatelessWidget {
  final Future<FirebaseApp> _initalization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initalization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Something went Wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: "home2",
            home: Home(),
            debugShowCheckedModeBanner: false,
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  CustomButton({
    this.title,
  });

  dynamic title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(80), bottomRight: Radius.circular(80)),
      child: Card(
        child: Container(
          alignment: Alignment.center,
          color: Colors.green,
          child: Text(title, style: GoogleFonts.lato(fontSize: 24)),
        ),
      ),
    );
  }
}
