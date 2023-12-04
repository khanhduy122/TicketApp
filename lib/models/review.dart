import 'package:json_annotation/json_annotation.dart';
part 'review.g.dart';

@JsonSerializable()
class Review {
  String id;
  String content;
  double rating;
  String? photoReview;
  String userName;
  String? userPhoto;
  int timestamp;

  Review({required this.id, required this.content, required this.userName, this.userPhoto, this.photoReview, required this.rating, required this.timestamp});

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}