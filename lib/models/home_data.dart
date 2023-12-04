
import 'package:ticket_app/models/banner.dart';
import 'package:ticket_app/models/movie.dart';

class HomeData{
  List<Banner> banners;

  List<Movie> nowShowing;

  List<Movie> comingSoon;

  HomeData({required this.banners, required this.comingSoon, required this.nowShowing});

}