import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_key.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/screen/splash_screen/bloc/get_data_app_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GetDataAppBloc getDataAppBloc = GetDataAppBloc();

  @override
  void initState() {
    super.initState();
    getDataAppBloc.add(GetDataAppEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: getDataAppBloc,
      listener: (_, state) async {
        _listenerSplash(state, context);
      },
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: 120.h,
            width: 120.w,
            child: Image.asset(
              AppAssets.imgLogo,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  void _listenerSplash(Object? state, BuildContext context) {
    if (state is GetDataAppState) {
      if (state.homeData != null) {
        context.read<DataAppProvider>().setHomeData(homeData: state.homeData!);
        context
            .read<DataAppProvider>()
            .setRecommendedCinema(cinemas: state.cinemasRecommended);
        checkIsFirst(context);
      }

      if (state.error != null) {
        debugLog(state.error.toString());
        if (state.error is NoInternetException) {
          DialogError.show(
            context: context,
            message:
                "Không có kết nối internet, vui lòng kiểm tra lại kết nối của bạn",
            onTap: () {
              SystemNavigator.pop();
            },
          );
          return;
        }

        DialogError.show(
          context: context,
          message: "Đã có lỗi xảy ra, vui lòng thử lại sau",
          onTap: () {
            SystemNavigator.pop();
          },
        );
      }
    }
  }

  Future<void> checkIsFirst(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.mainScreen, (route) => false);
    } else {
      await SharedPreferences.getInstance().then((prefs) {
        if (prefs.getBool(AppKey.checkIsFirstKey) == null) {
          prefs.setBool(AppKey.checkIsFirstKey, true);
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.onBoardingScreen, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.signInScreen, (route) => false);
        }
      });
    }
  }
}
