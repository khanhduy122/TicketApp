import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/widgets/text_from_field_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100.h),
            SizedBox(
              height: 90.h,
              width: 90.w,
              child: Image.asset(AppAssets.imgLogo, fit: BoxFit.fill),
            ),
            SizedBox(height: 20.h),
            Text(
              "Welcome Back, Movie Lover!",
              style: AppStyle.titleStyle,
            ),
            SizedBox(height: 20.h),
           
            TextFormFieldWidget(
              label: 'asdasd',
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                // Handle email address change
              
              }, 
            ),
            SizedBox(height: 20.h),
            TextFormFieldWidget(
              label: 'asdasd',
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                // Handle password change
              },
            )
          ],
        ),
      ),
    );
  }
}