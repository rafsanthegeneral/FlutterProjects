import 'dart:async';
//import 'dart:isolate';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:kimproject/dashboard/dashboard.dart';
import 'package:kimproject/dashboard/unknownperson.dart';
import 'package:kimproject/login.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard/knownperson.dart';
import 'library/firebase_options.dart';
import 'about.dart';

import 'package:kimproject/library/notification.dart';

//import 'library/firebasefile.dart';

// dynamic dataAsString = '';
// fetchDataAsString() {
//   DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
//   DatabaseReference child = databaseReference.child("users");

//   child.get().then((DataSnapshot snapshot) {
//     dynamic data = snapshot.value;
//     if (data != null) {
//       data.forEach((key, value) {
//         String date = value["date"];
//         String image = value["image"];
//         String type = value["type"];
//         // print('Key: $key, Date: $date, Image: $image, Type: $type');
//         //print(date);
//       });
//     }
//   });
// }

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// This widget is the root of your application.

class SplashScreen extends StatelessWidget {
  // Space Screen For Automatice Redirect
  const SplashScreen({super.key});
  void _redirect(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MyLogin(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _redirect(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200, // Set the height of the container
              width: 200,
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("images/cctv.png"),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: const FadeInImage(
                placeholder: AssetImage('images/cctv.png'),
                image: AssetImage('images/cctv.png'),
                fadeInDuration: Duration(milliseconds: 1500),
                fadeInCurve: Curves.easeIn,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Face Recognization Project',
                  textStyle: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 100),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ))
          ],
        ),
      ),
    );
  }
}

//Entry Point
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LocalNotificationService service;
  // String? _date;
  @override
  initState() {
    super.initState();
    // that is use for fetch data from firbase
    final DatabaseReference _databaseRef =
        FirebaseDatabase.instance.ref().child('intruder');

    _databaseRef.onValue.listen((event) {
      // null value protection
      if (event.snapshot.value != null) {
        setState(() {
          dynamic data = event.snapshot.value;
          // if (data != null) {
          //   data.forEach((key, value) {
          //     String date = value["date"];
          //     String image = value["image"];
          //     String type = value["type"];
          //     // print('Key: $key, Date: $date, Image: $image, Type: $type');
          //     // print(date);
          //   });
          // }
          if (data != null) {
            Map<String, dynamic> mapData = Map<String, dynamic>.from(data);
            List<String> keys = mapData.keys.toList();
            print(keys.length);
            for (int i = keys.length - 1; i >= 0;) {
              String key = keys[i];
              String date = data[key]["date"];
              //String image = data[key]["image"];
              //String type = data[key]["type"];
              print("=====>{$date}");
              // if any intruder Detected then get a notification
              notification(date);
              compute(notification, date);
              break;
            }
          }
        });
      }
    });
    service = LocalNotificationService(); //inisilizie Backgroud Prcess
    // notification();
  }

  notification(getdate) async {
    //service.showNotification(id: 0, title: getdate, body: "intruder Detected");

    // Timer.periodic(Duration(seconds: 2), (timer) async {
    //   // await service.showNotification(
    //   //     id: 0, title: dataAsString, body: "Starting");
    //   // print("background task running");
    //   // await service.showNotification(
    //   //     id: 0, title: "Intruder", body: "Intruder Detected");
    //   //snapshot.child('date').value.toString()
    // });

    // FirebaseAnimatedList(
    //   query: ref,
    //   defaultChild: Text("loading"),
    //   itemBuilder: (context, snapshot, animation, index) {
    //     service.showNotification(
    //         id: 0, title: "Intruder", body: "Intruder Detected");c
    //   },
    // );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/about': (context) => const AboutUs(),
        '/logout': (context) => const MyLogin(),
        '/knownpersone': (context) => const KnownPerson(),
        '/unknownperson': (context) => const UnknownPerson(),
        '/personalinfo': (context) => const PersonInfo()
      },
    );
  }
}
