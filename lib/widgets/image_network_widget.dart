import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/core/const/app_colors.dart';

class ImageNetworkWidget extends StatefulWidget {
  const ImageNetworkWidget(
      {super.key,
      required this.url,
      this.height,
      this.width,
      this.borderRadius,
      this.boxFit});

  final String url;
  final double? height;
  final double? width;
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
        height: widget.height,
        width: widget.width,
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
        height: widget.height ?? double.infinity,
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
            borderRadius: widget.borderRadius != null
                ? BorderRadius.circular(widget.borderRadius!.h)
                : null,
            color: AppColors.buttonPressColor),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.buttonColor,
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        height: widget.height ?? double.infinity,
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
            borderRadius: widget.borderRadius != null
                ? BorderRadius.circular(widget.borderRadius!.h)
                : null,
            color: AppColors.buttonPressColor),
        child: const Icon(Icons.error),
      ),
    );
  }
}
