import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/banner.dart';
import 'package:ticket_app/models/movie.dart';
part 'home_data.g.dart';

@JsonSerializable()
class HomeData {
  List<BannerHome> banners;

  List<Movie> nowShowings;

  List<Movie> comingSoons;

  HomeData(
      {required this.banners,
      required this.comingSoons,
      required this.nowShowings});

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}
