import 'actor.dart';
import 'enum_model.dart';
import 'review.dart';

class Movie {
  String? name;
  String? thumbnail;
  List<Category>? categories;
  double? rating;
  int? numberReview;
  String? date;
  int? duration;
  Languages? language;
  String? content;
  List<Actor>? actors;
  String? director;
  String? trailer;
  List<Review>? reviews;
  Status? status;
}