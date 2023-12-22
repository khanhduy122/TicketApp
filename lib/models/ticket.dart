
import 'cinema.dart';
import 'enum_model.dart';
import 'movie.dart';

class Ticket {
  Movie movie;
  TicketType ticketType;
  TypeSeat typeSeat;
  int number;
  int price;
  DateTime date;
  Cinema cinema;
  String chair;

  Ticket({required this.typeSeat, 
  required this.date, 
  required this.movie, 
  required this.number, 
  required this.price, 
  required this.ticketType, 
  required this.cinema, 
  required this.chair,
  });

}

