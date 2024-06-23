import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ticket_app/components/dialogs/dialog_confirm.dart';
import 'package:ticket_app/components/routes/route_name.dart';

class VerifyEmailController extends GetxController {
  late final Timer? _timer;
  final String email = Get.arguments as String;

  @override
  void onReady() {
    super.onReady();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkVerifyEmail();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _checkVerifyEmail() {
    FirebaseAuth.instance.currentUser?.reload();
    if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
      Get.toNamed(RouteName.mainScreen);
    }
  }

  Future<void> onWillPop() async {
    await DialogConfirm.show(
      context: Get.context!,
      message: "Bạn có chắc muốn hủy đăng kí tài khoản",
    ).then((value) {
      if (value) {
        deleteUser();
      }
    });
  }

  Future<void> deleteUser() async {
    try {
      FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {}
  }
}
