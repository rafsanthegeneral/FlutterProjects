import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esyearn/lib/globalAds.dart';
import 'package:esyearn/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Earnings Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.attach_money, color: Colors.green),
                title: Text(
                  'Your Earnings Detalis',
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to earnings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EarningsPage()),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Sign Out Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  bool shouldSignOut = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Sign Out'),
                        content: Text('Are you sure you want to sign out?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('Sign Out'),
                            onPressed: () async {
                              Navigator.of(context).pop(false);
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldSignOut == true) {}
                },
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.info, color: Colors.blue),
                title: Text(
                  'About Developer',
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to developer info page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeveloperInfoPage()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.contact_emergency, color: Colors.blue),
                title: Text(
                  'Contact App Owners ',
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to developer info page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Help()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for EarningsPage and LoginPage
class EarningsPage extends StatefulWidget {
  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  List<DataRow> rows = [];
  List<DataRow> dataList = [];
  @override
  void initState() {
    super.initState();
    _fetchUsers();
    loadAd();
  }

  Future<void> _fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('withdrawals')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy('withdrawMoney', descending: true)
          .get();
      print("---------------Query Sections ---------------------");

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          dataList = querySnapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;

            // Extract fields from each documen
            String name = data['name'] ?? 'Unknown';
            String txid = data['transid'] ?? ' Not Assine';

            Timestamp timestamp = data['time'] ?? Timestamp.now();
            DateTime dateTime = timestamp.toDate();
            String formattedTime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
            String withdrawMoney = data['withdrawMoney'].toString();
            int status = data['status'] ?? 'Unknonw';
            String statusText;
            Color statusColor;

            if (status == 0) {
              statusText = 'Rejected';
              statusColor = Colors.red;
            } else if (status == 1) {
              statusText = 'Pending';
              statusColor = Colors.orangeAccent;
            } else if (status == 2) {
              statusText = 'Done';
              statusColor = Colors.green;
            } else {
              statusText = 'Unknown';
              statusColor = Colors.grey;
            }
            // Create a DataRow using extracted data
            return DataRow(
              cells: [
                DataCell(Text(txid)),
                DataCell(Text(formattedTime)),
                DataCell(Text(withdrawMoney)),
                DataCell(
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                    ),
                  ),
                ),
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
      appBar: AppBar(
        title: Text('Earnings'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 30,
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Colors.blueGrey[200]!),
            columns: [
              DataColumn(
                  label: Text('Transaction ID',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Date',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Amount',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Status',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: rows,
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.amber;
      case 'Reject':
        return Colors.red;
      case 'Done':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}

class DeveloperInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Developer Info'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DeveloperCard(
                icon: Icons.person,
                label: 'Name',
                value: 'MD Rafsan',
              ),
              SizedBox(height: 15),
              DeveloperCard(
                icon: Icons.email,
                label: 'Email',
                value: 'rafsanthegeneral@gmail.com',
              ),
              SizedBox(height: 15),
              DeveloperCard(
                icon: Icons.phone,
                label: 'Phone',
                value: '09638102514',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  DeveloperCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Theme.of(context).primaryColor),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SelectableText(
                value,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContactInfo(
                icon: Icons.person,
                name: 'Md Zahid Hasan',
                phoneNumber: '01575364036',
              ),
              SizedBox(height: 15),
              ContactInfo(
                icon: Icons.person,
                name: 'Md. Nura Alam Siddique',
                phoneNumber: '01318187761',
              ),
              SizedBox(height: 15),
              ContactInfo(
                icon: Icons.person,
                name: 'Md. Mustafa Kabir Bappi',
                phoneNumber: '01600989856',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  final IconData icon;
  final String name;
  final String phoneNumber;

  ContactInfo(
      {required this.icon, required this.name, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Theme.of(context).primaryColor),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              SelectableText(
                'Call: $phoneNumber',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Help(),
  ));
}
