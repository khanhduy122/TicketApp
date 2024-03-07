import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_app/models/payment_card.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/components/vn_pay/api_key.dart';
import 'package:ticket_app/models/voucher.dart';

class PaymentRepo {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addMethodPayment(PaymentCard card) async {
    try {
      await _firestore
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Payments")
          .doc(card.cardNumber)
          .set(card.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMethodPayment(PaymentCard card) async {
    try {
      await _firestore
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Payments")
          .doc(card.cardNumber)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteVoucher(Voucher voucher) async {
    try {
      await _firestore
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Vouchers")
          .doc(voucher.id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PaymentCard>> getMethodPaymentUser() async {
    try {
      List<PaymentCard> listCard = [];
      final response = await _firestore
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Payments")
          .get();
      for (var element in response.docs) {
        listCard.add(PaymentCard.fromJson(element.data()));
      }
      return listCard;
    } catch (e) {
      return [];
    }
  }

  Future<String> getIpAddress() async {
    try {
      List<NetworkInterface> interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          return address.address;
        }
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  String hmacSHA512(String data) {
    try {
      List<int> hmacKeyBytes = utf8.encode(ApiKey.hashSecret);
      final Hmac hmacSha512 = Hmac(sha512, hmacKeyBytes);
      Uint8List dataBytes = Uint8List.fromList(utf8.encode(data));
      List<int> result = hmacSha512.convert(dataBytes).bytes;

      StringBuffer sb = StringBuffer();
      for (int byte in result) {
        sb.write(byte.toRadixString(16).padLeft(2, '0'));
      }

      return sb.toString();
    } catch (ex) {
      return '';
    }
  }
}
