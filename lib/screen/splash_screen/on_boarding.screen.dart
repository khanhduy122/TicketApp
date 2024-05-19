import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150.h,
              width: 150.w,
              child: Image.asset(
                AppAssets.imgLogo,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "New Experience",
              textAlign: TextAlign.center,
              style: AppStyle.titleStyle,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Watch a new movie much\neasier than any before",
              textAlign: TextAlign.center,
              style: AppStyle.defaultStyle,
            ),
            SizedBox(
              height: 40.h,
            ),
            ButtonWidget(
              title: "Get Started",
              height: 60.h,
              width: 250.w,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.signInScreen, (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
