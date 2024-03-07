import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/moduels/auth/auth_bloc.dart';
import 'package:ticket_app/moduels/auth/auth_event.dart';
import 'package:ticket_app/moduels/auth/auth_exception.dart';
import 'package:ticket_app/moduels/auth/auth_state.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/text_from_field_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: BlocProvider.of<AuthBloc>(context),
        listener: (context, state) {
          _onListenerSignIn(state, context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
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
                    "Welcome Back,\nMovie Lover!",
                    style: AppStyle.titleStyle,
                  ),
                  SizedBox(height: 20.h),
                  TextFormFieldWidget(
                    controller: _emailTextController,
                    validator: (value) {
                      return validatorEmail(value);
                    },
                    label: 'Email Address',
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 40.h),
                  TextFormFieldWidget(
                    controller: _passwordTextController,
                    label: 'Password',
                    obscureText: true,
                    validator: (value) {
                      return validatorPassword(value);
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
                        "Forgot Password?",
                        style: AppStyle.defaultStyle,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: ButtonWidget(
                      title: "Login",
                      height: 60.h,
                      width: 250.w,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context).add(SignInEvent(
                              context: context,
                              email: _emailTextController.text,
                              password: _passwordTextController.text));
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create new account? ",
                        style: AppStyle.defaultStyle,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteName.signUpScreen);
                          },
                          child: Text(
                            "Sign Up ",
                            style: AppStyle.defaultStyle
                                .copyWith(color: AppColors.buttonColor),
                          )),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(SignInWithGoogleEvent(context: context));
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
                  )
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         BlocProvider.of<AuthBloc>(context)
                  //             .add(SignInWithGoogleEvent());
                  //       },
                  //       child: SizedBox(
                  //         height: 64.h,
                  //         width: 64.w,
                  //         child: Image.asset(AppAssets.imgGoogle),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 20.w,
                  //     ),
                  //     SizedBox(
                  //       height: 64.h,
                  //       width: 64.w,
                  //       child: Image.asset(AppAssets.imgFacebook),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onListenerSignIn(Object? state, BuildContext context) {
    if (state is SignInState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }

      if (state.signInSuccess == true) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.mainScreen, (route) => false);
      }

      if (state.error != null) {
        Navigator.pop(context);
        if (state.error is TimeOutException) {
          DialogError.show(
              context: context,
              message: "Đã có lỗi xảy ra, vui lòng kiêm tra lại đường truyền");
        } else {
          if (state.error is UserNotFoundException) {
            DialogError.show(
                context: context,
                message: "Email này chưa được đăng kí trên hệ thống");
          } else {
            if (state.error is WrongPasswordException) {
              DialogError.show(
                  context: context, message: "Mật khẩu không chính xác");
            } else {
              DialogError.show(
                  context: context,
                  message: "Đã có lỗi xảy ra, vui lòng thử lại sao");
            }
          }
        }
      }
    }

    if (state is SignInWithGoogleState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }
      if (state.isSuccess == true) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.mainScreen, (route) => false);
      }
      if (state.error != null) {
        if (state.error is TimeOutException) {
          DialogError.show(
              context: context,
              message: "Đã có lỗi xảy ra, vui lòng kiêm tra lại đường truyền");
        } else {
          DialogError.show(
              context: context,
              message: "Đã có lỗi xảy ra, vui lòng thử lại sao");
        }
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
