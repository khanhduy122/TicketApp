import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/dialogs/dialog_confirm.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/dialogs/dialog_loading.dart';
import 'package:ticket_app/core/exceptions/exception.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/core/utils/upload_file_utils.dart';

class SignupController extends GetxController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final birthDayController = TextEditingController();
  final formSignUpKey = GlobalKey<FormState>();
  Rx<File?> imageSelected = Rx<File?>(null);
  DateTime? dateTimeSelected;
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    birthDayController.dispose();
    super.onClose();
  }

  void onTapSelectPhoto() async {
    try {
      final isGranted = await requestPermisstionPhoto();
      if (!isGranted) return;
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        imageSelected.value = File(image.path);
      }
    } catch (e) {
      debugLog(e.toString());
    }
  }

  Future<bool> requestPermisstionPhoto() async {
    final status = await Permission.photos.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      final result = await DialogConfirm.show(
        context: Get.context!,
        titleNegative: 'Không',
        titlePositive: 'Mở cài đặt',
        message: Platform.isAndroid
            ? 'Ứng dụng của chúng tôi cần quyền truy cập vào thư viện ảnh của bạn để có thể hoạt động đúng cách'
            : 'Ứng dụng của chúng tôi cần quyền truy cập vào thư viện ảnh của bạn để có thể hoạt động đúng cách\n\n1. chọn hình ảnh\n2. cho phép truy cập tất cả ảnh',
      );

      if (result) {
        openAppSettings();
        return false;
      }
      return false;
    } else {
      final result = await Permission.photos.request();
      return result.isGranted;
    }
  }

  void onTapEditBirthDay(BuildContext context) async {
    final result = await showDatePicker(
      context: context,
      currentDate: dateTimeSelected ?? DateTime(1900, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (result != null) {
      dateTimeSelected = result;
      birthDayController.text =
          DateFormat('dd/MM/yyyy').format(dateTimeSelected!);
    }
  }

  Future<void> signUpWithEmailPassword() async {
    try {
      DialogLoading.show(Get.context!);
      await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw TimeOutException(),
          );

      await _firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final user = _firebaseAuth.currentUser!;

      if (imageSelected.value != null) {
        final photoUrl =
            await UploadFileUtils.uploadAvatar(imageSelected.value!);
        user.updatePhotoURL(photoUrl);
      }
      user.updateDisplayName(fullNameController.text);
      user.sendEmailVerification();
      Get.back();
      Get.toNamed(
        RouteName.verifyScreen,
        arguments: {
          "email": emailController.text,
          "birthDay": birthDayController.text
        },
      );
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'weak_password') {
        DialogError.show(
          context: Get.context!,
          message: 'Mật khẩu quá yếu, vui lòng thử lại với mật khẩu khác',
        );
        return;
      }

      if (e.code == 'email-already-in-use') {
        DialogError.show(
          context: Get.context!,
          message: 'Email này đã được đăng kí',
        );
        return;
      }
      DialogError.show(
        context: Get.context!,
        message: 'Đã có lỗi xảy ra, vui lòng thử lại',
      );
    } catch (e) {
      Get.back();
      if (e is TimeOutException) {
        DialogError.show(
          context: Get.context!,
          message: 'Kết nói hết hạn, vui lòng kiểm tra lại đường truyền',
        );
      } else {
        DialogError.show(
          context: Get.context!,
          message: 'Đã có lỗi xảy ra, vui lòng thử lại',
        );
      }
    }
  }
}
