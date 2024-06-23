import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/screen/edit_profile_screen/edit_profile_controller.dart';
import 'package:ticket_app/widgets/button_back_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/text_from_field_widget.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        controller.onWillPop();
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: ButtonBackWidget(
                      onTap: () => controller.onWillPop(),
                    )),
                _buildAvatar(context),
                SizedBox(
                  height: 20.h,
                ),
                _buildTextFieldName(),
                SizedBox(
                  height: 20.h,
                ),
                _buildTextFieldBirthDay(),
                SizedBox(
                  height: 20.h,
                ),
                _buildTextFieldEmail(),
                SizedBox(
                  height: 40.h,
                ),
                _buildButtonSave(),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonSave() {
    return Obx(
      () => ButtonWidget(
        title: "Cập Nhật",
        height: 60.h,
        width: 250.w,
        color: controller.isEnableButton.value
            ? AppColors.buttonColor
            : AppColors.darkBackground,
        onPressed: () {
          if (!controller.isEnableButton.value) return;
          controller.saveEdit();
        },
      ),
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: controller.emailController,
      readOnly: true,
      style: AppStyle.defaultStyle.copyWith(color: Colors.grey[700]),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade700)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade700)),
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextFormFieldWidget(
      label: "Họ Và Tên",
      controller: controller.nameController,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng nhập tên của bạn";
        }
        return null;
      },
    );
  }

  Widget _buildTextFieldBirthDay() {
    return TextFormFieldWidget(
      controller: controller.birthDayController,
      readOnly: true,
      initValue: '01/01/1990',
      suffixIcon: GestureDetector(
        onTap: () => controller.onTapEditBirthDay(),
        child: const Icon(
          Icons.calendar_month,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.onTapSelectPhoto(),
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Stack(
            children: [
              Center(
                  child: controller.imageSelected.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(45.h),
                          child: Image.file(
                            controller.imageSelected.value!,
                            fit: BoxFit.cover,
                            height: 90.h,
                            width: 90.w,
                          ),
                        )
                      : (controller.user.photoURL == null)
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
                          : ImageNetworkWidget(
                              url: controller.user.photoURL!,
                              height: 90.h,
                              width: 90.w,
                              borderRadius: 45.h,
                            )),
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
    );
  }
}
