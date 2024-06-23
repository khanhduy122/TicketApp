import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:ticket_app/screen/sign/signin_controller.dart';

class SigninBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SigninController());
  }
}
