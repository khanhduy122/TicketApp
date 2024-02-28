import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable()
class Offer{
  final String thumbnail;
  final String title;
  final DateTime startTime;
  final DateTime expiredTime;
  final String content;
  final String offerApply;
  final String guide;

  Offer({required this.thumbnail, required this.title, required this.startTime, required this.expiredTime, required this.content, required this.offerApply, required this.guide});

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);
}