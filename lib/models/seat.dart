import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/enum_model.dart';
part 'seat.g.dart';

@JsonSerializable()
class Seat{
  String name;
  int status;
  int price;
  int index;
  @JsonKey(name: "type")
  TypeSeat typeSeat;
  String booked;

  Seat({required this.name, required this.status, required this.typeSeat, required this.price, required this.booked, required this.index});

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);

}