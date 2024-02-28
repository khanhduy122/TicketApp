import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ticket_app/models/voucher.dart';

class UserRepo {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<List<Voucher>> getListVoucher() {
    return _firestore.collection("User").doc(FirebaseAuth.instance.currentUser!.uid).collection("Vouchers").snapshots().map((response) {
      return response.docs.map((e) => Voucher.fromJson(e.data())).toList();
    });
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = FirebaseAuth.instance.currentUser!.uid;
      Reference firebaseStorageRef =
          _storage.ref().child('photo_user/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return Future.error(e);
    }
  }
}
