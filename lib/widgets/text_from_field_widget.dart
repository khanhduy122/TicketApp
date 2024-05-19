import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget(
      {super.key,
      this.label,
      this.hint,
      this.obscureText,
      this.textInputAction,
      this.initValue,
      this.controller,
      this.onChanged,
      this.validator,
      this.readOnly});

  final String? label;
  final String? hint;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final String? initValue;
  final bool? readOnly;
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool isShowHidePasseword = false;

  @override
  void initState() {
    super.initState();
    isShowHidePasseword = widget.obscureText ?? false;
    if (widget.controller != null && widget.initValue != null) {
      widget.controller!.text = widget.initValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: widget.readOnly ?? false,
      initialValue: (widget.initValue != null && widget.controller == null)
          ? widget.initValue
          : null,
      style: AppStyle.defaultStyle,
      obscureText: isShowHidePasseword,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppStyle.defaultStyle,
        helperStyle: AppStyle.defaultStyle,
        label: widget.label != null
            ? Text(widget.label ?? "", style: AppStyle.defaultStyle)
            : null,
        suffixIcon: widget.obscureText != null
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isShowHidePasseword = !isShowHidePasseword;
                  });
                },
                child: Container(
                  height: 10.h,
                  width: 10.w,
                  margin: EdgeInsets.only(right: 10.w),
                  child: Image.asset(
                    isShowHidePasseword
                        ? AppAssets.icHidePassword
                        : AppAssets.icShowPassword,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              )
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.textColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.buttonColor)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.textColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.red)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.textColor)),
      ),
    );
  }
}
