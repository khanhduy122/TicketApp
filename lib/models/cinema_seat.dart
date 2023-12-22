import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/enum_model.dart';
part 'cinema_seat.g.dart';

@JsonSerializable()
class CinemaSeat{
  String name;
  int status;
  TypeSeat typeSeat;

  CinemaSeat({required this.name, required this.status, required this.typeSeat});

  factory CinemaSeat.fromJson(Map<String, dynamic> json) => _$CinemaSeatFromJson(json);

  Map<String, dynamic> toJson() => _$CinemaSeatToJson(this);

}