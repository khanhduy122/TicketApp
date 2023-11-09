import 'package:flutter/material.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({super.key,  required this.label, this.obscureText , this.textInputAction , required this.onChanged});

  final String label;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final ValueChanged<String> onChanged;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
    

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppStyle.defaultStyle,
      obscureText: widget.obscureText ?? false,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        label: Text(widget.label, style: AppStyle.defaultStyle.copyWith(color: AppColors.textColor),),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.textColor
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.buttonColor
          )
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.textColor
          )
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.error
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.textColor
          )
        ),
      ),
    );
  }
}