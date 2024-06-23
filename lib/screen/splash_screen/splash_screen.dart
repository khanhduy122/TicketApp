import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/screen/splash_screen/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
