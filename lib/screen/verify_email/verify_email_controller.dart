import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/dialogs/dialog_confirm.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/dialogs/dialog_loading.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/user_info_model.dart';

class VerifyEmailController extends GetxController {
  late final Timer? _timer;
  final String birthDay = Get.arguments['birthDay'] as String;
  final email = Get.arguments['email'] as String;

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

  void _checkVerifyEmail() async {
    FirebaseAuth.instance.currentUser?.reload();
    if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
      _timer!.cancel();
      DialogLoading.show(Get.context!);
      final response = await signUp();
      Get.back();
      if (response != null) {
        Get.offAllNamed(RouteName.mainScreen);
        return;
      } else {
        deleteUser();
      }
    }
  }

  Future<UserInfoModel?> signUp() async {
    final user = FirebaseAuth.instance.currentUser!;

    await user.reload();

    final data = {
      "uid": user.uid,
      "displayName": user.displayName ?? "",
      "email": user.email ?? "",
      "photoUrl": user.photoURL ?? "",
      "birthDay": birthDay,
    };

    final response = await ApiCommon.post(url: ApiConst.signUp, data: data);

    if (response.data != null) {
      final user =
          UserInfoModel.fromJson(response.data as Map<String, dynamic>);
      Get.context!.read<DataAppProvider>().userInfoModel = user;
      return user;
    } else {
      Get.back();
      DialogError.show(context: Get.context!, message: response.error!.message);
      return null;
    }
  }

  Future<void> onWillPop() async {
    await DialogConfirm.show(
      context: Get.context!,
      message: "Bạn có chắc muốn hủy đăng kí tài khoản",
    ).then((value) {
      if (value) {
        deleteUser();
        Get.offAllNamed(RouteName.signInScreen);
      }
    });
  }

  Future<void> deleteUser() async {
    try {
      FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {}
  }
}
