
import 'package:ticket_app/models/ticket.dart';

abstract class SeatEvent{}

class HoldSeatEvent extends SeatEvent{
  final Ticket ticket;

  HoldSeatEvent({required this.ticket});
}

class DeleteSeatEvent extends SeatEvent{
  final Ticket ticket;

  DeleteSeatEvent({required this.ticket});
}