// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
      ticketId: json['ticketId'] as String?,
      uid: json['uid'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      movie: json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt(),
      seats: (json['seats'] as List<dynamic>?)
          ?.map((e) => ItemSeat.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: (json['price'] as num?)?.toInt(),
      cinema: json['cinema'] == null
          ? null
          : Cinema.fromJson(json['cinema'] as Map<String, dynamic>),
      showtimes: json['showtimes'] == null
          ? null
          : Time.fromJson(json['showtimes'] as Map<String, dynamic>),
      voucher: json['voucher'] == null
          ? null
          : Voucher.fromJson(json['voucher'] as Map<String, dynamic>),
      foods: (json['foods'] as List<dynamic>?)
          ?.map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'ticketId': instance.ticketId,
      'movie': instance.movie,
      'quantity': instance.quantity,
      'price': instance.price,
      'uid': instance.uid,
      'seats': instance.seats,
      'foods': instance.foods,
      'date': instance.date?.toIso8601String(),
      'showtimes': instance.showtimes,
      'voucher': instance.voucher,
      'cinema': instance.cinema,
    };
