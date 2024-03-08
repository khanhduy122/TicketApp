import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_app/models/ticket.dart';

class TicketRepo {
  final _firestore = FirebaseFirestore.instance;

  static Stream<List<Ticket>> getNewTickets() {
    return FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("NewTickets")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Ticket.fromJson(doc.data())).toList();
    });
  }

  static Stream<List<Ticket>> getExpiredTickets() {
    return FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("ExpiredTickets")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Ticket.fromJson(doc.data())).toList();
    });
  }

  Future<void> convertTicketToExpired() async {
    List<Ticket> tickets = [];

    try {
      final response = await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("NewTickets")
          .get();

      for (var ticket in response.docs) {
        tickets.add(Ticket.fromJson(ticket.data()));
      }

      for (var ticket in tickets) {
        if (checkExpiredTicket(ticket)) {
          await FirebaseFirestore.instance
              .collection('User')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("NewTickets")
              .doc(ticket.id)
              .delete();
          ticket.isExpired = 1;
          await FirebaseFirestore.instance
              .collection('User')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("ExpiredTickets")
              .doc(ticket.id)
              .set(ticket.toJson());
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  bool checkExpiredTicket(Ticket ticket) {
    String formnatShowtimnes = ticket.showtimes!.substring(8);
    DateTime formatDate = ticket.date!.add(Duration(
        hours: int.parse(formnatShowtimnes.substring(0, 2)),
        minutes: int.parse(formnatShowtimnes.substring(3)),
        seconds: 00));
    return formatDate.isBefore(DateTime.now());
  }

  Future<void> addTicket(Ticket ticket) async {
    try {
      await _firestore
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("NewTickets")
          .doc(ticket.id)
          .set(ticket.toJson());
      await _firestore
          .collection("Tickets")
          .doc(ticket.id)
          .set(ticket.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
