import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';

class ButtonBackWidget extends StatelessWidget {
  const ButtonBackWidget({super.key, this.onTap});

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
      child: SizedBox(
        height: 20.h,
        width: 20.w,
        child: Image.asset(
          AppAssets.icBack,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
