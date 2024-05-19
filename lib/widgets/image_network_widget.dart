import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_colors.dart';

class ImageNetworkWidget extends StatefulWidget {
  const ImageNetworkWidget(
      {super.key,
      required this.url,
      required this.height,
      required this.width,
      this.borderRadius,
      this.boxFit});

  final String url;
  final double height;
  final double width;
  final double? borderRadius;
  final BoxFit? boxFit;

  @override
  State<ImageNetworkWidget> createState() => _ImageNetworkWidgetState();
}

class _ImageNetworkWidgetState extends State<ImageNetworkWidget> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.url,
      imageBuilder: (context, imageProvider) => Container(
        height: widget.height.h,
        width: widget.width.w,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius != null
              ? BorderRadius.circular(widget.borderRadius!.h)
              : null,
          image: DecorationImage(
            image: imageProvider,
            fit: widget.boxFit ?? BoxFit.cover,
          ),
        ),
      ),
      placeholder: (_, __) => Container(
          height: widget.height.h,
          width: widget.width.w,
          decoration: BoxDecoration(
              borderRadius: widget.borderRadius != null
                  ? BorderRadius.circular(widget.borderRadius!.h)
                  : null,
              color: AppColors.buttonPressColor),
          child: const Center(child: CircularProgressIndicator())),
      errorWidget: (_, __, ___) => Container(
          height: widget.height.h,
          width: widget.width.w,
          decoration: BoxDecoration(
              borderRadius: widget.borderRadius != null
                  ? BorderRadius.circular(widget.borderRadius!.h)
                  : null,
              color: AppColors.buttonPressColor),
          child: const Icon(Icons.error)),
    );
  }
}
