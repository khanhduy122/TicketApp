import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/screen/signup/signup_controller.dart';
import 'package:ticket_app/widgets/button_back_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/text_from_field_widget.dart';

class SignUpScreen extends GetView<SignupController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: controller.formSignUpKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      const ButtonBackWidget(),
                      Expanded(
                          child: Text(
                        "Đăng Kí",
                        style: AppStyle.titleStyle,
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  GestureDetector(
                    onTap: controller.onTapSelectPhoto,
                    child: SizedBox(
                      height: 100.h,
                      width: 100.w,
                      child: Stack(
                        children: [
                          Obx(
                            () => Center(
                              child: controller.imageSelected.value == null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(45.h),
                                      child: SizedBox(
                                          height: 90.h,
                                          width: 90.w,
                                          child: Image.asset(
                                            AppAssets.imgAvatarDefault,
                                            fit: BoxFit.fill,
                                          )),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(45.h),
                                      child: SizedBox(
                                          height: 90.h,
                                          width: 90.w,
                                          child: Image.file(
                                            controller.imageSelected.value!,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Center(
                              child: SizedBox(
                                height: 25.h,
                                width: 25.w,
                                child: Image.asset(
                                  AppAssets.icAdd,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormFieldWidget(
                    controller: controller.fullNameController,
                    label: "Tên",
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập thông tin";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormFieldWidget(
                    controller: controller.emailController,
                    label: "Địa Chỉ Email",
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập thông tin";
                      } else {
                        final bool emailValid = RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value);
                        if (!emailValid) {
                          return "Email không hợp lệ";
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormFieldWidget(
                    controller: controller.passwordController,
                    obscureText: true,
                    label: "Mật Khẩu",
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập thông tin";
                      } else {
                        if (value.length < 6) {
                          return "Mật khẩu phải lớn hơn 6 kí tự";
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormFieldWidget(
                    label: "Xác Nhận Mật Khẩu",
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập thông tin";
                      } else {
                        if (controller.passwordController.text != value) {
                          return "Mật khẩu không trùng khớp";
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormFieldWidget(
                    controller: controller.birthDayController,
                    readOnly: true,
                    initValue: '01/01/1990',
                    suffixIcon: GestureDetector(
                      onTap: () => controller.onTapEditBirthDay(context),
                      child: const Icon(
                        Icons.calendar_month,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  ButtonWidget(
                      title: "Đăng Kí",
                      height: 60.h,
                      width: 250.w,
                      onPressed: () {
                        if (controller.formSignUpKey.currentState!.validate()) {
                          controller.signUpWithEmailPassword();
                        }
                      }),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
