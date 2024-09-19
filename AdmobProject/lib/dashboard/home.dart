import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic? balance;
  String? name;
  List<DataRow> dataList = [];
  List<DataRow> rows = [];
  @override
  void initState() {
    super.initState();
    _fetchBalance();
    _fetchUsers();
  }

  Future<void> _fetchBalance() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          balance = double.parse(docSnapshot['balance'].toStringAsFixed(3));
          name = docSnapshot['name'];
        });
      } else {
        print('Document does not exist');
        // Handle case where document doesn't exist
      }
    } catch (e) {
      print('Error fetching balance: $e');
      // Handle error
    }
  }

  Future<void> _fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('withdrawals')
          .orderBy('withdrawMoney', descending: true)
          .get();

      print("---------------Query Sections ---------------------");

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          dataList = querySnapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;

            // Extract fields from each documen
            String name = data['name'] ?? 'Unknown';
            print(name);

            String withdrawMoney = data['withdrawMoney'].toString();
            Timestamp timestamp = data['time'] ?? Timestamp.now();
            DateTime dateTime = timestamp.toDate();
            String formattedTime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
            // Create a DataRow using extracted data
            return DataRow(
              cells: [
                DataCell(Text(name)),
                DataCell(Text(withdrawMoney)),
                DataCell(Text(formattedTime)),
              ],
            );
          }).toList();
          rows = dataList;
        });
      } else {}
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 8, 2, 2)
                                  .withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    'https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png'),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'name: ${name}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${FirebaseAuth.instance.currentUser?.email}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Text(
                              //   'Phone: +8801234567890',
                              //   style: TextStyle(
                              //     color: Colors.black,
                              //     fontSize: 13,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 8, 2, 2)
                                  .withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'You Earning',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '৳ $balance',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
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
              SizedBox(height: 8),
              // Middle row

              SizedBox(height: 8),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 8, 2, 2).withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Users Income Board',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          fontFamily: 'Pacifico',
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.deepPurpleAccent.withOpacity(0.5),
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                          letterSpacing: 2.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        height: 350, // Set the height for the scrollable area
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis
                                .horizontal, // Enable horizontal scrolling if needed
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Withdraw')),
                                DataColumn(label: Text('Time')),
                              ],
                              rows: rows,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
