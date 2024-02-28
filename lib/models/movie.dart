import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/actor.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/review.dart';
part 'movie.g.dart';


@JsonSerializable()
class Movie {

  String? id;

  String? name;

  String? thumbnail;

  String? banner;

  List<Category>? categories;

  Ban? ban;

  String? date;

  double? rating;

  String? premiere;

  int? duration;

  List<Languages>? languages;

  String? content;

  @JsonKey(name: "total_review")
  int? totalReview;

  @JsonKey(name: "total_one_rating")
  int? totalOneRating;

  @JsonKey(name: "total_two_rating")
  int? totalTwoRating;

  @JsonKey(name: "total_three_rating")
  int? totalThreeRating;

  @JsonKey(name: "total_four_rating")
  int? totalFourRating;

  @JsonKey(name: "total_five_rating")
  int? totalFiveRating;

  @JsonKey(name: "total_rating_picture")
  int? totalRatingWithPicture;

  @JsonKey(name: "actor")
  List<Actor>? actors;

  String? director;

  String? trailer;

  List<Review>? reviews;

  int? status;

  String? nation;

  Movie({
     this.id,
     this.date,
     this.name,
     this.thumbnail,
    this.banner,
     this.categories,
     this.ban,
     this.actors,
    this.totalReview,
     this.content,
     this.director,
     this.duration,
     this.languages, 
     this.nation,
    this.premiere,
    this.rating,
    this.reviews,
     this.status,
     this.trailer
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);

  Map<String, dynamic> toJsonFirebase() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'categories': categories?.map((category) => category.name).toList(),
      'rating': rating,
      'duration': duration,
      'total_review': totalReview,
    };
  }

  String getCaterogies () {
    String category = "";

    for (var element in categories ?? []) {
      switch(element){
        case Category.drama: category += "Chính Kịch, ";
        case Category.romance: category += "Lãng Mạn, ";
        case Category.intense: category += "Gay Cấn, ";
        case Category.comedy: category += "Hài Hước, ";
        case Category.science_fiction: category += "Khoa Học Viễn Tưỡng, ";
        case Category.adventure: category += "Phiêu Lưu, ";
        case Category.act: category += "Hành Động, "; 
        case Category.fantasy: category += "Giả Tưởng, ";
        case Category.mentality: category += "Tâm Lý, ";
        case Category.criminal: category += "Tội Phạm, ";
        case Category.horrified: category += "Kinh Dị, ";
      }
    }
   
    return category;
  }

  String getLanguages() {
    String language = "";
    for (var element in languages ?? []) {
      switch(element){
        case Languages.subtitle : language += "Phụ Đề, ";
        case Languages.voice: language += "Thuyết Minh, ";
      }
    }
    
    return language.substring(0, language.length - 2);
  }

  String getBan () {

    String stringBan = "";
    switch(ban ?? ""){
      case Ban.c13: 
        stringBan = "13+";
        break;
      case Ban.c16:
        stringBan = "16+";
        break;
      case Ban.c18:
        stringBan = "18+";
        break;
      case Ban.p:
        stringBan = "P";
        break;
    }

    return stringBan;
  }
}