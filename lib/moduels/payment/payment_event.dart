
import 'package:ticket_app/models/payment_card.dart';
import 'package:ticket_app/models/ticket.dart';

abstract class PaymentEvent{}

class CreateURLEvent extends PaymentEvent {}

class AddMethodPayment extends PaymentEvent{
  Map<String, dynamic> card;

  AddMethodPayment({required this.card});
}

class GetMethodPaymentUserEvent extends PaymentEvent{}

class HandleErrorCreateTokenEvent extends PaymentEvent {
  String responseCode;

  HandleErrorCreateTokenEvent({required this.responseCode});
}

class CreatePaymentUrlEvent extends PaymentEvent{
  PaymentCard paymentCard;
  Ticket ticket;

  CreatePaymentUrlEvent({required this.paymentCard, required this.ticket});
}

class AddTicketEvent extends PaymentEvent{
  Ticket ticket;

  AddTicketEvent({required this.ticket});
}

class PaymentCancleEvent extends PaymentEvent{
  Ticket ticket;

  PaymentCancleEvent({required this.ticket});
}
