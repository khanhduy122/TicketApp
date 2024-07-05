import 'package:get/get.dart';
import 'package:ticket_app/screen/select_cinema/select_cinema_controller.dart';

class SelectCinemaBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SelectCinemaController());
  }
}
