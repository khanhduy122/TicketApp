import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/screen/sign_in/signin_controller.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/text_from_field_widget.dart';

class SignInScreen extends GetView<SigninController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                SizedBox(
                  height: 90.h,
                  width: 90.w,
                  child: Image.asset(AppAssets.imgLogo, fit: BoxFit.fill),
                ),
                Text(
                  "Chào Mừng Đến Với\nMovie Ticket",
                  style: AppStyle.titleStyle,
                ),
                SizedBox(height: 20.h),
                TextFormFieldWidget(
                  controller: controller.emailTextController,
                  validator: (value) {
                    return controller.validatorEmail(value);
                  },
                  label: 'Email',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 40.h),
                TextFormFieldWidget(
                  controller: controller.passwordTextController,
                  label: 'Mật Khẩu',
                  obscureText: true,
                  validator: (value) {
                    return controller.validatorPassword(value);
                  },
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, RouteName.forgotPasswordScreen);
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Quên Mật Khẩu",
                      style: AppStyle.defaultStyle,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Center(
                  child: ButtonWidget(
                    title: "Đăng Nhập",
                    height: 60.h,
                    width: 250.w,
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.signInWithEmailPassword();
                      }
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bạn chưa có tài khoản? ",
                      style: AppStyle.defaultStyle,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RouteName.signUpScreen);
                        },
                        child: Text(
                          "Đăng kí",
                          style: AppStyle.defaultStyle
                              .copyWith(color: AppColors.buttonColor),
                        )),
                  ],
                ),
                SizedBox(height: 40.h),
                GestureDetector(
                  onTap: () {
                    controller.signInWithGoogle();
                  },
                  child: Container(
                    height: 50.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: AppColors.darkBackground,
                        borderRadius: BorderRadius.circular(20.h)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40.h,
                          width: 40.w,
                          child: Image.asset(AppAssets.imgGoogle),
                        ),
                        Text(
                          "Đăng Nhập Với Google",
                          style: AppStyle.defaultStyle,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
