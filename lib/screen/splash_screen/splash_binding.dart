import 'package:get/instance_manager.dart';
import 'package:ticket_app/screen/splash_screen/splash_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
