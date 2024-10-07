import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kimproject/library/publicvar.dart';

final auth = FirebaseAuth.instance;
final intruderRef = FirebaseDatabase.instance.ref("intruder");
final knownRef = FirebaseDatabase.instance.ref("knownperson");

void deleteDataFromIntruder(dynamic key, dynamic imageURL) {
  final ref = FirebaseDatabase.instance.ref("intruder");

  try {
    final storageRef = FirebaseStorage.instance.refFromURL(imageURL);
    storageRef.delete().then((_) {
      print("Storage data deleted successfully");
    }).catchError((error) {
      print("Failed to delete storage data: $error");
    });
    ref.child(key).remove();
  } catch (e) {
    ref.child(key).remove();
  }
}

void deleteDataFromKnown(dynamic key, dynamic imageURL) {
  final ref = FirebaseDatabase.instance.ref("knownperson");

  try {
    final storageRef = FirebaseStorage.instance.refFromURL(imageURL);
    storageRef.delete().then((_) {
      print("Storage data deleted successfully");
    }).catchError((error) {
      print("Failed to delete storage data: $error");
    });
    ref.child(key).remove();
  } catch (e) {
    ref.child(key).remove();
  }
}

Future<void> addPerson(String string1, String string2, String string3) async {
  try {
    // Generate a unique ID for the image
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    // Create a reference to the Firebase Storage location
    Reference storageReference =
        FirebaseStorage.instance.ref().child('/known/$imageName');

    // Upload the image file to Firebase Storage
    UploadTask uploadTask =
        storageReference.putFile(File(PubicImageStoreVar.imagePathValue.value));
    TaskSnapshot storageSnapshot = await uploadTask;

    // Get the download URL of the uploaded image
    String imageUrl = await storageSnapshot.ref.getDownloadURL();

    // Create a new entry in the "intruder" node of Firebase Realtime Database
    await knownRef.push().set({
      'image_url': imageUrl,
      'name': string1,
      'degination': string2,
      'type': string3,
      'timestamp': DateTime.now().toString(),
    });
    final file = File(PubicImageStoreVar.imagePathValue.value);
    file.delete();
    print('Image and strings uploaded successfully.');
  } catch (error) {
    print('Error uploading image and strings: $error');
  }
}
