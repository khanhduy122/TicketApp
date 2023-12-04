import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  late final User user;

  @override
  void initState() {
    super.initState();
    user = context.read<DataAppProvider>().user!;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h,),
              _avatarProfie(context) ,
              SizedBox(height: 40.h,),
              _itemOption(
                icon: AppAssets.icProfile, 
                title: "Thông Tin",
                onTap: () {
                  Navigator.pushNamed(context, RouteName.editProfileScreen);
                },
              ),
              _itemOption(
                icon: AppAssets.icPassword, 
                title: "Thay Đổi Mật Khẩu",
                onTap: () {
                  
                },
              ),
              _itemOption(
                icon: AppAssets.icVoucher, 
                title: "Voucher",
                onTap: () {
                  
                },
              ),
              _itemOption(
                icon: AppAssets.icSuport, 
                title: "Hổ Trợ",
                onTap: () {
                  
                },
              ),
              SizedBox(height: 20.h,),
              ButtonWidget(
                title: "Đăng Xuất", 
                height: 50.h, 
                width: 250.w, 
                onPressed: () {
                  
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _avatarProfie(BuildContext context) {
    return Column(
      children: [
        Container(
          child: user.photoURL == null ? SizedBox(
            height: 100.h,
            width: 10.w,
            child: Image.asset(AppAssets.imgAvatarDefault),
          ) : ImageNetworkWidget(
            url: context.read<DataAppProvider>().user!.photoURL!, 
            height: 100.h, 
            width: 100.w,
            borderRadius: 50.h,
          )
        ),
        SizedBox(height: 20.h,),
        Text(user.displayName!,
          style: AppStyle.titleStyle,
        ),
        SizedBox(height: 10.h,),
        Text(user.email!,
          style: AppStyle.defaultStyle,
        ),
      ],
    );
  }
}

Widget _itemOption({required String icon, required String title, required Function() onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 30.h,
                width: 30.w,
                child: Image.asset(icon, fit: BoxFit.cover,)
              ),
              SizedBox(width: 10.w,),
              Text(title, style: AppStyle.defaultStyle,)
            ],
          ),
          DashedDivider(
            color: Colors.white,
            height: 20.0.h,
            width: 2.0.w,
            dashLength: 5.0.w,
            dashGap: 3.0.w,
          ),
          SizedBox(height: 20.h,),
        ],
      ),
    );
}

class DashedDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final double dashLength;
  final double dashGap;

  const DashedDivider({
    super.key, 
    required this.color,
    required this.height,
    required this.width,
    required this.dashLength,
    required this.dashGap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedDividerPainter(
        color: color,
        width: width,
        dashLength: dashLength,
        dashGap: dashGap,
      ),
      child: Container(
        height: height,
      ),
    );
  }
}

class DashedDividerPainter extends CustomPainter {
  final Color color;
  final double width;
  final double dashLength;
  final double dashGap;

  DashedDividerPainter({
    required this.color,
    required this.width,
    required this.dashLength,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = width;

    double startY = size.height / 2;

    for (double startX = 0; startX < size.width; startX += dashLength + dashGap) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + dashLength, startY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}