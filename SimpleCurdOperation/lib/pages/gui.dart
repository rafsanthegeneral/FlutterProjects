import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/pages/adding.dart';
import 'package:test_app/pages/update.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Gui extends StatefulWidget {
  @override
  _GuiState createState() => _GuiState();
}

class _GuiState extends State<Gui> {
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('Students').snapshots();
  @override
  CollectionReference students =
      FirebaseFirestore.instance.collection('Students');

  Future<void> deleteuser(id) {
    return students.doc(id).delete().then((value) {});
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: studentsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something is Error in There ");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedata = [];

          snapshot.data.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedata.add(a);
            a['id'] = document.id;
            print(storedata);
          }).toList();

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.8, horizontal: 0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Curd Operation By  Rafsan '),
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Adding(),
                          ),
                        )
                      },
                      child: Text('Add', style: TextStyle(fontSize: 20.0)),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.deepPurple),
                    )
                  ],
                ),
              ),
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: const <int, TableColumnWidth>{
                    1: FixedColumnWidth(140)
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: Container(
                          color: Colors.greenAccent,
                          child: Center(
                            child: Text(
                              "Names",
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: Colors.greenAccent,
                          child: Center(
                            child: Text(
                              "Email",
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: Colors.greenAccent,
                          child: Center(
                            child: Text(
                              "Action",
                            ),
                          ),
                        ),
                      ),
                    ]),
                    for (var i = 0; i < storedata.length; i++) ...[
                      TableRow(children: [
                        TableCell(
                          child: Container(
                            child: Center(
                              child: Text(
                                storedata[i]['name'],
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            child: Center(
                              child: Text(
                                storedata[i]['email'],
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Update(id: storedata[i]['id']),
                                  ),
                                ),
                              },
                              icon: Icon(Icons.create),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            IconButton(
                              onPressed: () {
                                deleteuser(storedata[i]['id']);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        )),
                      ]),
                    ],
                  ],
                ),
              ),
            ),
          );
        });
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
