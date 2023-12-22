
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/movie.dart';

class Cinema {
  String? id;
  String? thumbnail;
  String? name;
  CinemasType? cinemasType;
  List<Movie>? movies;
  double? lat;
  double? long;
  double? distance;
  String? address;

  Cinema({required this.id ,required this.address, required this.name, required this.thumbnail, required this.cinemasType});

  Cinema.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'] ?? "";
    name = json['name'] ?? "";
    thumbnail = json["thumbnail"];
    cinemasType = json["cinemas"] == "CGV" ? CinemasType.CGV : json["cinemas"] == "Lotte" ? CinemasType.Lotte : CinemasType.Galaxy;
    lat = json["lat"];
    long = json["long"];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'name': name,
      'cinemas': cinemasType!.name,
      'lat': lat,
      'long': long,
      'address': address,
    };
  }

  String getDistanceFormat(){
    if(distance! >= 1000){
      return "${distance! ~/ 1000},${(distance! % 1000) ~/ 100 .toInt()} km";
    }else{
      return "${distance!.toInt()} m";
    }
    
  }
}