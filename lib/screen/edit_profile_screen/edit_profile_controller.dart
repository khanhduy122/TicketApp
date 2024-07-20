import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/const/net_work_info.dart';
import 'package:ticket_app/core/dialogs/dialog_confirm.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/dialogs/dialog_loading.dart';
import 'package:ticket_app/core/utils/datetime_util.dart';
import 'package:ticket_app/core/utils/upload_file_utils.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/user_info_model.dart';
import 'package:ticket_app/screen/main_screen/profile/profile_controller.dart';

class EditProfileController extends GetxController {
  UserInfoModel user = Get.context!.read<DataAppProvider>().userInfoModel!;
  Rx<File?> imageSelected = Rx<File?>(null);
  final emailController = TextEditingController();
  final birthDayController = TextEditingController();
  final nameController = TextEditingController();
  DateTime? dateTimeSelected;
  RxBool isEnableButton = false.obs;
  final profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    emailController.text = user.email;
    nameController.text = user.displayName;
    birthDayController.text = user.birthDay;
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
      currentDate:
          dateTimeSelected ?? DateTimeUtil.stringToDateTime(user.birthDay),
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
      String? photoUrl;
      if (imageSelected.value != null) {
        photoUrl = await UploadFileUtils.uploadAvatar(imageSelected.value!);
      }

      final data = {
        'uid': user.uid,
        'email': user.email,
        'photoUrl': photoUrl ?? user.photoUrl,
        'displayName': nameController.text,
        'birthDay': birthDayController.text,
      };
      final respose = await ApiCommon.post(
        url: ApiConst.editProfile,
        data: data,
      );
      Get.back();
      if (respose.data != null) {
        user = UserInfoModel.fromJson(respose.data);
        Get.context!.read<DataAppProvider>().userInfoModel = user;
        profileController.photoUrl.value = user.photoUrl;
        profileController.name.value = user.displayName;
        Get.until((route) => route.isFirst);
      } else {
        DialogError.show(
          context: Get.context!,
          message: respose.error!.message,
        );
      }
    } catch (e) {
      Get.back();
      debugLog(e.toString());
    }
  }
}
