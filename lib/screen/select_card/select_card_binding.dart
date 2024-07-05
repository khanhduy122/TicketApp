import 'package:get/get.dart';
import 'package:ticket_app/screen/select_card/select_card_controller.dart';

class SelectCardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SelectCardController());
  }
}
