import 'package:ticket_app/models/cinema.dart';

class CinemaCity {
  String name;

  List<Cinema> all;

  List<Cinema> cgv;

  List<Cinema> lotte;

  List<Cinema> galaxy;

  CinemaCity({
    required this.cgv,
    required this.galaxy,
    required this.lotte,
    required this.all,
    required this.name,
  });

  factory CinemaCity.fromJson(Map<String, dynamic> json) {
    final listCGV = (json['CGV'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
    final listGalaxy = (json['Galaxy'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
    final listLotte = (json['Lotte'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
    return CinemaCity(
      cgv: listCGV,
      galaxy: listGalaxy,
      lotte: listLotte,
      name: json["name"],
      all: listCGV.sublist(0) + listGalaxy.sublist(0) + listLotte.sublist(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "CGV": cgv.map((cinema) => cinema.toJson()).toList(),
      "Lotte": lotte.map((cinema) => cinema.toJson()).toList(),
      "Galaxy": galaxy.map((cinema) => cinema.toJson()).toList(),
    };
  }
}
