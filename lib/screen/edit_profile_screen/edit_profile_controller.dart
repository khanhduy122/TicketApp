import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/const/net_work_info.dart';
import 'package:ticket_app/components/dialogs/dialog_confirm.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/utils/upload_file_utils.dart';
import 'package:ticket_app/screen/main_screen/profile/profile_controller.dart';

class EditProfileController extends GetxController {
  User user = FirebaseAuth.instance.currentUser!;
  Rx<File?> imageSelected = Rx<File?>(null);
  final emailController = TextEditingController();
  final birthDayController = TextEditingController();
  final nameController = TextEditingController();
  DateTime? dateTimeSelected;
  RxBool isEnableButton = false.obs;
  final profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    emailController.text = user.email ?? '';
    nameController.text = user.displayName ?? '';
    birthDayController.text = '01/01/1990';
    nameController.addListener(() {
      checkIsChange();
    });
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    birthDayController.dispose();
    super.onClose();
  }

  void checkIsChange() {
    if (nameController.text != user.displayName ||
        imageSelected.value != null ||
        dateTimeSelected != null) {
      isEnableButton.value = true;
    } else {
      isEnableButton.value = false;
    }
  }

  void onTapEditBirthDay() async {
    final result = await showDatePicker(
      context: Get.context!,
      currentDate: dateTimeSelected ?? DateTime(1900, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (result != null) {
      dateTimeSelected = result;
      birthDayController.text =
          DateFormat('dd/MM/yyyy').format(dateTimeSelected!);
      checkIsChange();
    }
  }

  Future<void> onWillPop() async {
    if (isEnableButton.value) {
      await DialogConfirm.show(
              context: Get.context!, message: "Bạn có chắc muốn hủy thay đổi ?")
          .then((isConfirm) {
        if (isConfirm) {
          Get.back();
        }
      });
    } else {
      Get.until((route) => route.isFirst);
    }
  }

  void onTapSelectPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        imageSelected.value = File(image.path);
        checkIsChange();
      }
    } catch (e) {
      debugLog(e.toString());
    }
  }

  void saveEdit() async {
    try {
      if (await NetWorkInfo.isConnectedToInternet() == false) {
        DialogError.show(
          context: Get.context!,
          message: 'Không có kết nói nóo Internet',
        );
        return;
      }
      DialogLoading.show(Get.context!);

      if (nameController.text != user.displayName) {
        await user.updateDisplayName(nameController.text);
        profileController.name.value = nameController.text;
      }

      if (imageSelected.value != null) {
        String? photoUrl =
            await UploadFileUtils.uploadAvata(imageSelected.value!);
        await user.updatePhotoURL(photoUrl);
        profileController.photoUrl.value = photoUrl;
      }
      Get.back();
      Get.until((route) => route.isFirst);
    } catch (e) {
      Get.back();
      debugLog(e.toString());
    }
  }
}
