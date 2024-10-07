//import 'dart:async';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../library/firebasefile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';

class UnknownPerson extends StatefulWidget {
  const UnknownPerson({super.key});

  @override
  State<UnknownPerson> createState() => _UnknownPersonState();
}

class _UnknownPersonState extends State<UnknownPerson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        title: const Text(
          "Unknown Person",
          style: TextStyle(
            color: Color.fromARGB(255, 5, 2, 2),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                color: Color.fromARGB(255, 248, 242, 242),
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
              child: FirebaseAnimatedList(
            query: intruderRef,
            defaultChild: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  "Loading Data ....",
                  style: TextStyle(fontSize: 30),
                ))
              ],
            ),
            itemBuilder: (context, snapshot, animation, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: ListTile(
                  title: Column(
                    children: [
                      Text(
                        snapshot.child('date').value.toString(),
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 2, 2),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                              color: Colors.grey,
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Notification'),
                                content: Text('That Will be in Future Update'),
                              );
                            },
                          );
                        },
                        child: Text('Register as Known'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors
                              .blue, // sets the text color of the button
                          padding: EdgeInsets.symmetric(
                              horizontal: 16), // sets the padding of the button
                          shape: RoundedRectangleBorder(
                            // sets the shape of the button
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 5, // sets the elevation of the button
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Yes or no Dialog
                          showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                title: Text(
                                  'Delete Item?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to delete this item?',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // alert Box Close
                                      Navigator.pop(context, false);
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                      try {
                                        deleteDataFromIntruder(
                                            snapshot.key,
                                            snapshot
                                                .child('image')
                                                .value
                                                .toString());
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Notification'),
                                              content:
                                                  Text('Deleted Success Fully'),
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Notification'),
                                              content: Text('Error ==>{$e}'),
                                            );
                                          },
                                        );
                                      }
                                      // Alert Box Close After Delete
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 12, 61, 223),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Delete This Data'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 241, 11,
                              11), // sets the text color of the button
                          padding: EdgeInsets.symmetric(
                              horizontal: 16), // sets the padding of the button
                          shape: RoundedRectangleBorder(
                            // sets the shape of the button
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 5, // sets the elevation of the button
                        ),
                      )
                    ],
                  ),
                  subtitle: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(), // show the progress indicator
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 131, 11, 243),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.all(5.0),
                        child: Image.network(
                          snapshot.child('image').value.toString(),
                          fit:
                              BoxFit.cover, // set the scaling mode of the image
                        ),
                      ),
                    ],
                  ),
                  splashColor: Colors.red,
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
