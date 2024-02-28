
import 'package:ticket_app/models/payment_card.dart';

class PaymentState{}

class CreateURLState extends PaymentState{
  Object? error;
  bool? isLoading;
  String? createTokenUrl;

  CreateURLState({this.error, this.isLoading, this.createTokenUrl});
}

class AddMethodPaymentState extends PaymentState{
  bool? isLoading;
  bool? isSuccess;
  Object? error;

  AddMethodPaymentState({this.error, this.isLoading, this.isSuccess});
}

class GetMethodPaymentUserState extends PaymentState{
  bool? isLoading;
  List<PaymentCard>? listCard;
  Object? error;

  GetMethodPaymentUserState({this.error, this.isLoading, this.listCard});
}

class CreatePaymentUrlState extends PaymentState{
  bool? isLoading;
  String? paymentUrl;
  Object? error;

  CreatePaymentUrlState({this.error, this.isLoading, this.paymentUrl});
}

class AddTicketState extends PaymentState{
  bool? isLoading;
  bool? isSuccess;
  Object? error;

  AddTicketState({this.error, this.isLoading, this.isSuccess});
}

class CheckTicketState extends PaymentState{
  bool? isLoading;
  bool? isSuccess;
  Object? error;

  CheckTicketState({this.error, this.isLoading, this.isSuccess});
}