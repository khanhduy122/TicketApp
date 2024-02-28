import 'package:json_annotation/json_annotation.dart';
part 'review.g.dart';

@JsonSerializable()
class Review {
  String id;
  String content;
  double rating;
  List<String>? images;
  String userName;
  String? userPhoto;
  int timestamp;

  Review({required this.id, required this.content, required this.userName, this.userPhoto, this.images, required this.rating, required this.timestamp});

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}