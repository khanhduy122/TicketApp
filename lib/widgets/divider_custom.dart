
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DividerCustom extends StatelessWidget {

  const DividerCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedDividerPainter(),
      child: Container(
        height: 2.h,
      ),
    );
  }
}

class DashedDividerPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.w;

    double startY = size.height / 2;

    for (double startX = 0;
        startX < size.width;
        startX += 5.w + 3.w) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + 5.w, startY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}