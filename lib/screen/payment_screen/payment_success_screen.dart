import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset(AppAssets.imgCheck)),
            SizedBox(height: 20.h,),
            Text(
              "Thanh Toán Thành Công",
              style: AppStyle.titleStyle
            ),
            SizedBox(height: 10.h,),
            Text(
              "Cảm ơn bạn đã tin tưởng và đặt vé tại Ticket App!",
              textAlign: TextAlign.center,
              style: AppStyle.defaultStyle
            ),
            SizedBox(height: 100.h,),
            ButtonWidget(
              title: "Tiếp Tục", 
              height: 60.h, 
              width: 250.w, 
              onPressed: (){
                Navigator.popUntil(context, (route) => route.settings.name == RouteName.mainScreen);
              }
            ),
            SizedBox(height: 10.h,)
          ],
        )
      ),
    );
  }
}