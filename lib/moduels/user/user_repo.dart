import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepo {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = FirebaseAuth.instance.currentUser!.uid;
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('photo_user/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
}
