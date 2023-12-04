import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Languages {voice, subtitle}

@JsonEnum()
// ignore: constant_identifier_names
enum Category {drama, romance, intense, comedy, science_fiction, adventure, act, fantasy, mentality, horrified, criminal}

@JsonEnum()
enum TicketType {d2, d3}

@JsonEnum()
// ignore: constant_identifier_names
enum ChairType {sweetbox, normal, VIP}

@JsonEnum()
enum Ban {c13, c16, c18, p}

@JsonEnum()
// ignore: constant_identifier_names
enum CinemasType {CGV, Lotte, Galaxy}