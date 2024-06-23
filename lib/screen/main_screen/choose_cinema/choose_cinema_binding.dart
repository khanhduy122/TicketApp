import 'package:get/get.dart';
import 'package:ticket_app/screen/main_screen/choose_cinema/choose_cinema_controller.dart';

class ChooseCinemaBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ChooseCinemaController());
  }
}
