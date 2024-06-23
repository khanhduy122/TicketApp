import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadFileUtils {
  static final _storage = FirebaseStorage.instance;

  static Future<String?> uploadAvata(File file) async {
    try {
      String fileName = FirebaseAuth.instance.currentUser!.uid;
      Reference firebaseStorageRef =
          _storage.ref().child('photo_user/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
