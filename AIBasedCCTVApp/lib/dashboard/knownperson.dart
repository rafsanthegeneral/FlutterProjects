import 'dart:async';
//import 'dart:io';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:kimproject/library/personcard.dart';
import 'package:kimproject/library/publicvar.dart';
import '../library/capimage.dart';
import '../library/firebasefile.dart';
//import '../library/firebasefile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';

class KnownPerson extends StatefulWidget {
  const KnownPerson({super.key});

  @override
  State<KnownPerson> createState() => _KnownPersonState();
}

class _KnownPersonState extends State<KnownPerson> {
  Color buttonColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    startColorAnimation();
  }

  void startColorAnimation() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        buttonColor =
            buttonColor == Color.fromARGB(255, 2, 13, 22).withOpacity(0.7)
                ? Colors.green.withOpacity(0.7)
                : Color.fromARGB(255, 198, 243, 33).withOpacity(0.7);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        title: const Text(
          "Known Person",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: FirebaseAnimatedList(
                  query: knownRef,
                  defaultChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Loading Data ....",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                  itemBuilder: (context, snapshot, animation, index) {
                    return Container(
                      height: 220,
                      // Adjust the height as needed
                      child: ListTile(
                        title: Column(
                          children: [
                            PersonalCard(
                              index: snapshot.key,
                              image:
                                  snapshot.child('image_url').value.toString(),
                              title: snapshot.child('name').value.toString(),
                              description:
                                  snapshot.child('degination').value.toString(),
                              additionalInfo:
                                  snapshot.child('type').value.toString(),
                            ),
                          ],
                        ),
                        splashColor: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 50.0,
            right: 140.0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 2),
              curve: Curves.easeInOut,
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: buttonColor,
              ),
              child: IconButton(
                onPressed: () {
                  print(PubicImageStoreVar.imagePathValue.value);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImageCapturePopup();
                    },
                  ).then((value) {
                    if (value != null) {
                      Navigator.pushNamed(context, '/personalinfo');
                    }
                  });

                  // Add your logic for the "Add People" button here
                },
                icon: Icon(
                  Icons.add,
                  size: 36.0,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PersonInfo extends StatefulWidget {
  const PersonInfo({super.key});

  @override
  State<PersonInfo> createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
  @override
  Widget build(BuildContext context) {
    return ImageInfoDialog(imagePath: PubicImageStoreVar.imagePathValue.value);
  }
}
