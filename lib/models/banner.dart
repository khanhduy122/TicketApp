import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/offer.dart';
import 'package:ticket_app/models/voucher.dart';
part 'banner.g.dart';

@JsonSerializable()
class BannerHome {
  @JsonKey(name: '_id')
  String id;
  String thumbnail;
  int type;
  String? movieId;
  Voucher? voucher;
  Offer? offers;

  BannerHome(
      {required this.id,
      required this.thumbnail,
      required this.type,
      this.movieId,
      this.offers,
      this.voucher});

  factory BannerHome.fromJson(Map<String, dynamic> json) =>
      _$BannerHomeFromJson(json);

  Map<String, dynamic> toJson() => _$BannerHomeToJson(this);
}
