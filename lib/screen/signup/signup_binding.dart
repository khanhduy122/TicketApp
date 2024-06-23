import 'package:get/get.dart';
import 'package:ticket_app/screen/signup/signup_controller.dart';

class SignupBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SignupController());
  }
}
