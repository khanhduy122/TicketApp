import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_confirm.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/moduels/auth/auth_bloc.dart';
import 'package:ticket_app/moduels/auth/auth_event.dart';
import 'package:ticket_app/moduels/auth/auth_state.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String codeOTP1 = "";
  String codeOTP2 = "";
  String codeOTP3 = "";
  String codeOTP4 = "";
  String codeOTP5 = "";
  String codeOTP6 = "";
  final StreamController _controllerButtonVerify = StreamController();
  late final Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      BlocProvider.of<AuthBloc>(context).add(CheckVerifyEvent());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controllerButtonVerify.close();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _onWillPop(context);
      },
      child: BlocListener(
        bloc: BlocProvider.of<AuthBloc>(context),
        listenWhen: (previous, current) {
          return current is CheckVerifyState || current is DeleteUserState;
        },
        listener: (context, state) {
          _onListenerVerifyScreen(state, context);
        },
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250.h,
                    width: 200.w,
                    child: Image.asset(
                      AppAssets.imgVerifyCode,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Xác Nhận",
                    style: AppStyle.titleStyle,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Chúng tôi đã gửi email đến ",
                          style: AppStyle.defaultStyle,
                          children: [
                            TextSpan(
                                text: widget.email,
                                style: AppStyle.defaultStyle
                                    .copyWith(color: AppColors.buttonColor)),
                            TextSpan(
                                text:
                                    " kèm theo liên kết để truy cập lại vào tài khoản của bạn.",
                                style: AppStyle.defaultStyle),
                          ])),
                  SizedBox(
                    height: 20.h,
                  ),
                  ButtonWidget(
                      title: "Hủy",
                      height: 50.h,
                      width: 250.w,
                      onPressed: () async => await _onWillPop(context))
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }

  void _onListenerVerifyScreen(Object? state, BuildContext context) {
    if (state is CheckVerifyState) {
      if (state.isVerifyEmail == true) {
        if (_timer != null) {
          _timer!.cancel();
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.mainScreen, (route) => false);
        }
      }
    }

    if (state is DeleteUserState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }
      if (state.isSuccess == true) {
        Navigator.popUntil(
            context, (route) => route.settings.name == RouteName.signInScreen);
      } else {
        DialogError.show(
            context: context,
            message: "Đã có lỗi xảy ra, vui lòng thử lại sao");
      }
    }
  }

  Future<void> _onWillPop(BuildContext context) async {
    await DialogConfirm.show(
            context: context, message: "Bạn có chắc muốn hủy đăng kí tài khoản")
        .then((value) {
      if (value) {
        BlocProvider.of<AuthBloc>(context).add(DeleteUserEvent());
        if (_timer != null) {
          _timer!.cancel();
        }
        debugLog("pop");
        Navigator.pop(context);
      }
    });
  }
}
