import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/food.dart';
import 'package:ticket_app/models/seat.dart';
import 'package:ticket_app/models/showtimes.dart';
import 'package:ticket_app/models/voucher.dart';
import 'cinema.dart';
import 'movie.dart';
part 'ticket.g.dart';

@JsonSerializable()
class Ticket {
  String? ticketId;
  Movie? movie;
  int? quantity;
  int? price;
  String? uid;
  List<ItemSeat>? seats;
  List<FoodItem>? foods;
  DateTime? date;
  Time? showtimes;
  Voucher? voucher;
  Cinema? cinema;

  Ticket({
    this.ticketId,
    this.uid,
    this.date,
    this.movie,
    this.quantity,
    this.seats,
    this.price,
    this.cinema,
    this.showtimes,
    this.voucher,
    this.foods,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);

  String formatDateTime() {
    return "${showtimes!.time}, ${date!.day}-${date!.month}-${date!.year}";
  }

  String getSeatString() {
    String result = "";
    for (var element in seats!) {
      result += "${element.name}, ";
    }
    return result.substring(0, result.length - 2);
  }
}
