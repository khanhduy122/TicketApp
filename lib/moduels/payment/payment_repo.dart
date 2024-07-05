import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_app/models/payment_card.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/components/vn_pay/vnp_key.dart';
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
}
