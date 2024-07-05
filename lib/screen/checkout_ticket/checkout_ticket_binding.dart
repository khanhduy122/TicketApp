import 'package:get/get.dart';
import 'package:ticket_app/screen/checkout_ticket/checkout_ticket_controller.dart';

class CheckoutTicketBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CheckoutTicketController());
  }
}
