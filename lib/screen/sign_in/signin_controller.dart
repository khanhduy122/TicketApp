import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/components/api/api_common.dart';
import 'package:ticket_app/components/api/api_const.dart';
import 'package:ticket_app/components/const/net_work_info.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/exceptions/exception.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/user_info_model.dart';

class SigninController extends GetxController {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void onClose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.onClose();
  }

  Future<void> signInWithEmailPassword() async {
    DialogLoading.show(Get.context!);
    if (!await NetWorkInfo.isConnectedToInternet()) {
      DialogError.show(
        context: Get.context!,
        message: 'Không có kết nối Internet',
      );
      return;
    }
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(
            email: emailTextController.text,
            password: passwordTextController.text,
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw TimeOutException(),
          )
          .catchError((error) {
        throw error;
      });
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.back();
        DialogError.show(
          context: Get.context!,
          message: 'Đã có lỗi xảy ra, vui lòng thử lại',
        );
        return;
      } else {
        if (user.emailVerified) {
          final response = await getUserInfo(uid: user.uid);
          Get.back();
          if (response != null) {
            Get.offAllNamed(RouteName.mainScreen);
          }
        } else {
          Get.back();
          user.sendEmailVerification();
          Get.toNamed(
            RouteName.verifyScreen,
            arguments: {
              "email": user.email,
              "birthDay": "01/01/1900",
            },
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'user-not-found') {
        DialogError.show(
          context: Get.context!,
          message: 'Email chưa được đăng kí trên hệ thống',
        );
        return;
      }

      if (e.code == 'wrong-password') {
        DialogError.show(
          context: Get.context!,
          message: 'Tài khoản hoặc mật khẩu không chính xác, vui lòng thử lại',
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
          message: 'Kết nối hết hạn, vui lòng kiểm tra lại đường truyền',
        );
      } else {
        DialogError.show(
          context: Get.context!,
          message: 'Đã có lỗi xảy ra, vui lòng thử lại',
        );
      }
    }
  }

  Future<UserInfoModel?> getUserInfo({required String uid}) async {
    final response = await ApiCommon.get(
      url: ApiConst.signIn,
      queryParameters: {"uid": uid},
    );
    if (response.data != null) {
      final user = UserInfoModel.fromJson(response.data);
      Get.context!.read<DataAppProvider>().userInfoModel = user;
      return user;
    } else {
      DialogError.show(
        context: Get.context!,
        message: response.error!.message,
      );
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser;

    googleUser = await googleSignIn.signIn().catchError((onError) => null);

    try {
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication.timeout(
          const Duration(seconds: 20),
          onTimeout: () => throw TimeOutException(),
        );

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        DialogLoading.show(Get.context!);

        await FirebaseAuth.instance.signInWithCredential(credential).timeout(
              const Duration(seconds: 20),
              onTimeout: () => throw TimeOutException(),
            );
        Get.offAllNamed(RouteName.mainScreen);
      }
    } catch (e) {
      if (e is TimeOutException) {
        DialogError.show(
          context: Get.context!,
          message: 'Kết nối hết hạn, vui lòng kiểm tra lại đường truyền',
        );
      } else {
        DialogError.show(
          context: Get.context!,
          message: 'Đã có lỗi xảy ra, vui lòng thử lại',
        );
      }
    }
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

  String? validatorPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập thông tin";
    } else {
      if (value.length < 6) {
        return "Mật khẩu phải lớn hơn 6 kí tự";
      }
    }
    return null;
  }
}
