import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadFileUtils {
  static final _storage = FirebaseStorage.instance;

  static Future<String?> uploadAvatar(File file) async {
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

  static Future<List<String>> uploadImageReview(
      {required List<File> files,
      required String movieId,
      required String fileName}) async {
    try {
      final listUrl = <String>[];
      for (var i = 0; i < files.length; i++) {
        final firebaseStorageRef =
            _storage.ref().child('review/$movieId/$fileName$i');
        final uploadTask = firebaseStorageRef.putFile(files[i]);
        final taskSnapshot = await uploadTask;
        final url = await taskSnapshot.ref.getDownloadURL();
        listUrl.add(url);
      }

      return listUrl;
    } catch (e) {
      return [];
    }
  }
}
