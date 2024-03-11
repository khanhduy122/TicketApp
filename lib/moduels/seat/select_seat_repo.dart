import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/seat.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/moduels/seat/seat_exception.dart';

class SelectSeatRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<List<Seat>> getListSeatCinema(
      {required Cinema cinema,
      required Movie movie,
      required String date,
      required String showtimes}) {
    return FirebaseFirestore.instance
        .collection("Cinemas")
        .doc(cinema.cityName)
        .collection(cinema.type.name)
        .doc(cinema.id)
        .collection(date)
        .doc(movie.id)
        .collection(showtimes)
        .orderBy('index', descending: false)
        .snapshots()
        .map((snapshot) {
      List<Seat> seats = [];
      for (var element in snapshot.docs) {
        seats.add(Seat.fromJson(element.data()));
      }
      return seats;
    });
  }

  Future<void> holdSeat({required Ticket ticket}) async {
    List<Seat> seatsBooked = [];
    for (var seat in ticket.seats!) {
      if (await isBooked(ticket: ticket, seat: seat)) {
        seatsBooked.add(seat);
      } else {
        await _firestore
            .collection("Cinemas")
            .doc(ticket.cinema!.cityName)
            .collection(ticket.cinema!.type.name)
            .doc(ticket.cinema!.id)
            .collection(formatDate(ticket.date!))
            .doc(ticket.movie!.id)
            .collection("${ticket.showtimes} - ${ticket.cinema!.rooms![0].id}")
            .doc(seat.name)
            .update({"status": 1});
      }
    }
    if (seatsBooked.isEmpty) {
      return;
    }

    await deleteListSeatNotBooked(ticket: ticket, seatsBooked: seatsBooked);
    throw SeatReservedException();
  }

  Future<void> bookSeat({required Ticket ticket, required Seat seat}) async {
    await _firestore
        .collection("Cinemas")
        .doc(ticket.cinema!.cityName)
        .collection(ticket.cinema!.type.name)
        .doc(ticket.cinema!.id)
        .collection(formatDate(ticket.date!))
        .doc(ticket.movie!.id)
        .collection("${ticket.showtimes} - ${ticket.cinema!.rooms![0].id}")
        .doc(seat.name)
        .update(
            {"status": 1, "booked": FirebaseAuth.instance.currentUser!.uid});
  }

  Future<void> deleteSelectSeat({required Ticket ticket}) async {
    for (var element in ticket.seats!) {
      final response = await _firestore
          .collection("Cinemas")
          .doc(ticket.cinema!.cityName)
          .collection(ticket.cinema!.type.name)
          .doc(ticket.cinema!.id)
          .collection(formatDate(ticket.date!))
          .doc(ticket.movie!.id)
          .collection("${ticket.showtimes} - ${ticket.cinema!.rooms![0].id}")
          .doc(element.name)
          .get();
      if (response.data()!["booked"] != "") {
        continue;
      } else {
        await _firestore
            .collection("Cinemas")
            .doc(ticket.cinema!.cityName)
            .collection(ticket.cinema!.type.name)
            .doc(ticket.cinema!.id)
            .collection(formatDate(ticket.date!))
            .doc(ticket.movie!.id)
            .collection("${ticket.showtimes} - ${ticket.cinema!.rooms![0].id}")
            .doc(element.name)
            .update({"status": 0});
      }
    }
  }

  Future<void> deleteListSeatNotBooked(
      {required Ticket ticket, required List<Seat> seatsBooked}) async {
    List<Seat> seats = [];
    for (var element in ticket.seats!) {
      bool isBooked = false;
      for (var seat in seatsBooked) {
        if (element.name == seat.name) {
          isBooked = true;
          break;
        }
      }
      if (!isBooked) {
        seats.add(element);
      }
    }

    for (var element in seats) {
      await _firestore
          .collection("Cinemas")
          .doc(ticket.cinema!.cityName)
          .collection(ticket.cinema!.type.name)
          .doc(ticket.cinema!.id)
          .collection(formatDate(ticket.date!))
          .doc(ticket.movie!.id)
          .collection("${ticket.showtimes} - ${ticket.cinema!.rooms![0].id}")
          .doc(element.name)
          .update({"status": 0, 'booked': ""}).catchError((e) {
        return Future.error(e);
      });
    }
  }

  Future<void> cancelBookSeat({required Ticket ticket}) async {
    for (var element in ticket.seats!) {
      await _firestore
          .collection("Cinemas")
          .doc(ticket.cinema!.cityName)
          .collection(ticket.cinema!.type.name)
          .doc(ticket.cinema!.id)
          .collection(formatDate(ticket.date!))
          .doc(ticket.movie!.id)
          .collection("${ticket.showtimes} - ${ticket.cinema!.rooms![0].id}")
          .doc(element.name)
          .update({"booked": ""});
    }
  }

  Future<bool> checkSeatBooked({required Ticket ticket}) async {
    try {
      List<Seat> seatsBooked = [];
      for (var element in ticket.seats!) {
        final response = await _firestore
            .collection("Cinemas")
            .doc(ticket.cinema!.cityName)
            .collection(ticket.cinema!.type.name)
            .doc(ticket.cinema!.id)
            .collection(formatDate(ticket.date!))
            .doc(ticket.movie!.id)
            .collection("${ticket.showtimes} - ${ticket.cinema!.rooms![0].id}")
            .doc(element.name)
            .get()
            .catchError((e) {
          deleteListSeatNotBooked(ticket: ticket, seatsBooked: seatsBooked);
          throw e;
        });

        if (response.data()!["status"] == 0 ||
            response.data()!["booked"] == "") {
          await bookSeat(ticket: ticket, seat: element);
          continue;
        } else {
          seatsBooked.add(element);
        }
      }

      if (seatsBooked.isEmpty) {
        return true;
      }

      await deleteListSeatNotBooked(ticket: ticket, seatsBooked: seatsBooked);
      return false;
    } catch (e) {
      return false;
    }
  }

  String formatDate(DateTime dateTime) {
    String day = dateTime.day.toString().length == 1
        ? "0${dateTime.day}"
        : dateTime.day.toString();
    String month = dateTime.month.toString().length == 1
        ? "0${dateTime.month}"
        : dateTime.month.toString();
    return "$day-$month-${dateTime.year}";
  }

  Future<bool> isBooked({required Ticket ticket, required Seat seat}) async {
    try {
      final response = await _firestore
          .collection("Cinemas")
          .doc(ticket.cinema!.cityName)
          .collection(ticket.cinema!.type.name)
          .doc(ticket.cinema!.id)
          .collection(formatDate(ticket.date!))
          .doc(ticket.movie!.id)
          .collection("${ticket.showtimes} - ${ticket.cinema!.rooms![0].id}")
          .doc(seat.name)
          .get();

      if (response.data()!["status"] == 0) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
