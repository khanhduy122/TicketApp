

import 'package:json_annotation/json_annotation.dart';
part 'actor.g.dart';

@JsonSerializable()
class Actor {
  String thumbnail;
  String name;

  Actor({required this.name, required this.thumbnail});

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);

  Map<String, dynamic> toJson() => _$ActorToJson(this);
}