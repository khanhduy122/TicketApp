import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticket_app/components/dialogs/dialog_completed.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/screen/forgot_password/forgot_password_controller.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/text_from_field_widget.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: "Đặt Lại Mật Khẩu"),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            Form(
              key: controller.formKey,
              child: TextFormFieldWidget(
                controller: controller.emailController,
                validator: (value) {
                  return controller.validatorEmail(value);
                },
                label: 'Đại chỉ Email',
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Obx(() => ButtonWidget(
                  title: "Xác Nhận",
                  height: 50.h,
                  width: 250.w,
                  color: controller.isEnableButton.value
                      ? Colors.blue
                      : Colors.grey,
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      DialogConpleted.show(
                          context: context,
                          message:
                              "Đã gửi yêu cầu đặt lại mật khẩu, Vui lòng kiểm tra email của bạn để đặt lại mật khẩu",
                          onTap: () => Navigator.popUntil(
                              context,
                              (route) =>
                                  route.settings.name ==
                                  RouteName.signInScreen));
                    }
                  },
                ))
          ],
        ),
      )),
    );
  }
}
