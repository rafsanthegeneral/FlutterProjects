import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<User?> singUpWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String uid = credential.user!.uid;

      // Store additional user info in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        // Initialize balance
        'name': username,
        'balance': 2.00,
        'uid': uid,
      });

      return credential.user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> singInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class Operation {
  Future<void> insert() async {}
  Future<void> updateBlance(dynamic data) async {
    // Store additional user info in Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    double getbalance = snapshot['balance'] + data;
    double newbalance = double.parse(getbalance.toStringAsFixed(3));
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      // Initialize balance
      'balance': newbalance,
    });
  }
}
