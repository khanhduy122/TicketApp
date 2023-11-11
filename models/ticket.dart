
import 'cinema.dart';
import 'enum_model.dart';
import 'food.dart';
import 'movie.dart';

class Ticket {
  Movie movie;
  TicketType ticketType;
  ChairType chairType;
  int number;
  int price;
  DateTime date;
  Cinema cinema;
  String chair;
  Food? food;

  Ticket({required this.chairType, 
  required this.date, 
  required this.movie, 
  required this.number, 
  required this.price, 
  required this.ticketType, 
  required this.cinema, 
  required this.chair,
  this.food
  });

}

