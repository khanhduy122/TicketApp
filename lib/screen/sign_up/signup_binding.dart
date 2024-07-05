import 'package:get/get.dart';
import 'package:ticket_app/screen/sign_up/signup_controller.dart';

class SignupBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SignupController());
  }
}
