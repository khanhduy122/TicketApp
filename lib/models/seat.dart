import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/enum_model.dart';
part 'seat.g.dart';

@JsonSerializable()
class Seat {
  String showtimesId;
  List<ItemSeat> seats;

  Seat({
    required this.seats,
    required this.showtimesId,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);
}

@JsonSerializable()
class ItemSeat {
  String name;
  int status;
  int index;
  @JsonKey(name: "type")
  TypeSeat typeSeat;
  String booked;

  ItemSeat(
      {required this.name,
      required this.status,
      required this.typeSeat,
      required this.booked,
      required this.index});

  factory ItemSeat.fromJson(Map<String, dynamic> json) =>
      _$ItemSeatFromJson(json);

  Map<String, dynamic> toJson() => _$ItemSeatToJson(this);
}
