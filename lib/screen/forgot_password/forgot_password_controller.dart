import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxBool isEnableButton = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      if (emailController.text.isNotEmpty) {
        isEnableButton.value = true;
      } else {
        isEnableButton.value = false;
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void sendLinkResetPassword() {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
    } catch (e) {}
  }

  String? validatorEmail(String? value) {
    final bool emailValid =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
            .hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return "Vui lòng nhập thông tin";
    } else {
      if (!emailValid) {
        return "Địa chỉ email không hợp lệ";
      }
    }
    return null;
  }
}
