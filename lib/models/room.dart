
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room{
   String? id;
   String? name;
   int? column;
   int? row;

  Room({ this.column,  this.id,  this.name,  this.row});

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

}