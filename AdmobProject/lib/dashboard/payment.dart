import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esyearn/lib/globalAds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = false;
  dynamic? balance;
  double? needBlanace = 0.0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController amount = TextEditingController();
  @override
  void initState() {
    super.initState();

    loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350, // You can adjust the width as needed
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // bKash Logo Banner
            Image.network(
              'https://seeklogo.com/images/B/bkash-logo-250D6142D9-seeklogo.com.png',
              height: 50,
            ),
            SizedBox(height: 20),
            // Mobile Number Field
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: mobileNumber,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter mobile number';
                      } else if (value.length < 11) {
                        return 'Mobile number must be at least 11 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: amount,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 53, 3, 235)),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              String getmobilenumber = mobileNumber.text;
                              double? getamount = double.tryParse(amount.text);

                              DocumentSnapshot docSnapshot =
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .get();

                              // Ensure balance is parsed as a double
                              String name = docSnapshot['name'];
                              double balance = docSnapshot['balance'] is double
                                  ? docSnapshot['balance']
                                  : double.tryParse(
                                          docSnapshot['balance'].toString()) ??
                                      0.0;
                              print(balance);
                              print(getamount);
                              print(getmobilenumber);
                              if (balance < 10.00) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Minimum Balance '),
                                      content: Text(
                                          'Minimum Balance Should be 10 tk'),
                                      actions: [
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                              if (balance > 10.00) {
                                if (getamount! < balance) {
                                  print(
                                      "Yes i Success Fully Enter -----------");
                                  double getbalance = balance - getamount;
                                  double newbalance = double.parse(
                                      getbalance.toStringAsFixed(3));
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .update({
                                    'balance': newbalance,
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('withdrawals')
                                      .add({
                                    'name': name,
                                    'userId':
                                        FirebaseAuth.instance.currentUser?.uid,
                                    'withdrawMoney': getamount,
                                    'time': DateTime.now(),
                                    'transid': '',
                                    'phone': getmobilenumber,
                                    'status':
                                        1, // or any other status you want to represent
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Success'),
                                        content: Text(
                                            'Your Withdraw Is Pending Now'),
                                        actions: [
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Withdraw Error '),
                                        content: Text(
                                            'Withdraw Amount Cannot be Greater Then Your Balance'),
                                        actions: [
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                                setState(() {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              }
                              setState(() {
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            } // Handle withdrawal logic here
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 30.0),
                          ),
                          child: Text('Make Withdraw'),
                        ),
                ],
              ),
            ),
            // TextField(
            //   controller: mobileNumber,
            //   decoration: InputDecoration(
            //     labelText: 'Mobile Number',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20),
            // TextField(
            //   controller: amount,
            //   decoration: InputDecoration(
            //     labelText: 'Amount',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //   ),
            //   keyboardType: TextInputType.number,
            // ),

            SizedBox(height: 20),
            // Withdraw Button
          ],
        ),
      ),
    );
  }
}
