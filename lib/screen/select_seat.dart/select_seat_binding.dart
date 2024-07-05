import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:ticket_app/screen/select_seat.dart/select_seat_controller.dart';

class SelectSeatBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SelectSeatController());
  }
}
