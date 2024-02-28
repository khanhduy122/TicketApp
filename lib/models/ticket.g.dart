// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
      id: json['id'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      movie: json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
      quantity: json['quantity'] as int?,
      seats: (json['seats'] as List<dynamic>?)
          ?.map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: json['price'] as int?,
      cinema: json['cinema'] == null
          ? null
          : Cinema.fromJson(json['cinema'] as Map<String, dynamic>),
      showtimes: json['showtimes'] as String?,
      isExpired: json['isExpired'] as int?,
    );

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'id': instance.id,
      'movie': instance.movie,
      'quantity': instance.quantity,
      'price': instance.price,
      'seats': instance.seats,
      'date': instance.date?.toIso8601String(),
      'showtimes': instance.showtimes,
      'cinema': instance.cinema,
      'isExpired': instance.isExpired,
    };
