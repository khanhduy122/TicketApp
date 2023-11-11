

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/widgets/button_negative_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class DialogConfirm {

  static Future<bool> show (BuildContext context, String message) async{
    bool isConfirm = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          children:[
              Container(
              height: 300.h,
              width: 300.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20.h)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h,),
                  SizedBox(
                    height: 100.h,
                    width: 100.w,
                    child: Image.asset(AppAssets.imgLogo, fit: BoxFit.contain,),
                  ),
                  SizedBox(height: 10.h,),
                  Text("Xác Nhận",  style: AppStyle.titleStyle,),
                  SizedBox(height: 10.h,),
                  Text(message,  style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp), textAlign: TextAlign.center,),
                  SizedBox(height: 40.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonNegativeWidget(
                        title: "No", 
                        height: 50.h, 
                        width: 100.w, 
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      SizedBox(width: 20.w,),
                      ButtonWidget(
                        title: "OK", 
                        height: 50.h, 
                        width: 100.w, 
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]
        );
      },
    );
    return isConfirm;
  }
}
