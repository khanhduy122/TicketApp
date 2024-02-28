import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/dialogs/dialog_completed.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/moduels/auth/auth_bloc.dart';
import 'package:ticket_app/moduels/auth/auth_event.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/text_from_field_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  String emailAddress = "";
  final _formKey = GlobalKey<FormState>();
  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: "Đặt Lại Mật Khẩu"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 40.h,),
              Form(
                key: _formKey,
                child: TextFormFieldWidget(
                  validator: (value) {
                    return validatorEmail(value);
                  },
                  label: 'Email Address',
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    setState(() {
                      emailAddress = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 40.h,),
              ButtonWidget(
                title: "Ok", 
                height: 50.h, 
                width: 250.w, 
                color: emailAddress.isEmpty ? Colors.grey : Colors.blue,
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    _authBloc.add(SendLinkResetPasswordEvent(email: emailAddress));
                    DialogConpleted.show(
                      context: context,
                      message: "Đã gửi yêu cầu đặt lại mật khẩu, Vui lòng kiểm tra email của bạn để đặt lại mật khẩu",
                      onTap: () => Navigator.popUntil(context, (route) => route.settings.name == RouteName.signInScreen)
                    );
                  }
                },
              )
            ],
          ),
        )
      ),
    );
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