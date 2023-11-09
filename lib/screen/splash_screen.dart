import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/routes/app_router.gr.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

      context.replaceRoute(const OnBoardingRoute());

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