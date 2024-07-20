import 'package:get/get.dart';
import 'package:ticket_app/screen/main_screen/ticket/my_ticket_controller.dart';

class MyTicketBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MyTicketController());
  }
}
