import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:ticket_app/screen/select_food/select_food_controller.dart';

class SelectFoodBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SelectFoodController());
  }
}
