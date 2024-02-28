import 'package:ticket_app/models/cinema.dart';

class CinemaCity {
  String? name;

  List<Cinema>? all;

  List<Cinema>? cgv;

  List<Cinema>? lotte;

  List<Cinema>? galaxy;

  CinemaCity({required this.cgv, required this.galaxy, required this.lotte, required this.all, required this.name});

  CinemaCity.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    cgv = (json['CGV'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
    galaxy = (json['Galaxy'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
    lotte = (json['Lotte'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "CGV": cgv?.map((cinema) => cinema.toJson()).toList(),
      "Lotte": lotte?.map((cinema) => cinema.toJson()).toList(),
      "Galaxy": galaxy?.map((cinema) => cinema.toJson()).toList(),
    };
  }
}
