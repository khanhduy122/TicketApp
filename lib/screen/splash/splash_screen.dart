import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/routes/route_name.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) { 

      
    Timer.periodic(const Duration(seconds: 3), (timer) { 
      timer.cancel();
      Navigator.pushNamedAndRemoveUntil(context, RouteName.onBoardingScreen, (route) => false);
    });

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 120.h,
          width: 120.w,
          child: Image.asset(AppAssets.imgLogo, fit: BoxFit.fill,),
        ),
      ),
    );
  }
  
}