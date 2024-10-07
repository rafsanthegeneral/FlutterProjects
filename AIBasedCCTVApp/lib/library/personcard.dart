//import 'dart:async';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';
//import '../library/firebasefile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kimproject/library/firebasefile.dart';

//import 'package:flutter/src/widgets/placeholder.dart';
class PersonalCard extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String additionalInfo;
  final dynamic index;

  PersonalCard({
    required this.index,
    required this.image,
    required this.title,
    required this.description,
    required this.additionalInfo,
  });

  @override
  State<PersonalCard> createState() => _PersonalCardState();
}

class _PersonalCardState extends State<PersonalCard> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SizedBox(
        height: 210,
        child: Card(
          elevation: 10.0,
          margin: const EdgeInsets.all(3.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Stack(
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
                        widget.image,
                        fit: BoxFit.cover,
                        height: 160.0,
                        width: 150.0, // set the scaling mode of the image
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          widget.description,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          widget.additionalInfo,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          children: [
                                            Text(
                                                "This Will Come in Future Update"),
                                          ],
                                        );
                                      });
                                  // Edit button logic
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors
                                      .blue, side: BorderSide(
                                      color:
                                          Colors.blue), // Set the border color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Set the border radius
                                  ),
                                ),
                                child: Text('Edit'),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
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
                                                deleteDataFromKnown(
                                                    widget.index, widget.image);
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text('Notification'),
                                                      content: Text(
                                                          'Deleted Success Fully'),
                                                    );
                                                  },
                                                );
                                              } catch (e) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text('Notification'),
                                                      content:
                                                          Text('Error ==>{$e}'),
                                                    );
                                                  },
                                                );
                                              }
                                              // Alert Box Close After Delete
                                            },
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 12, 61, 223),
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // Edit button logic
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Color.fromARGB(255, 252, 10,
                                      10), side: BorderSide(
                                      color: Color.fromARGB(255, 243, 4,
                                          4)), // Set the border color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Set the border radius
                                  ),
                                ),
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
