
import 'package:flutter/material.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/widgets/button_back_widget.dart';

AppBar appBarWidget({String? title}){
  return AppBar(
    leading: const ButtonBackWidget(),
    centerTitle: true,
    title: title == null ? null : Text(title, style: AppStyle.titleStyle, maxLines: 2,),
    elevation: 0,
    backgroundColor: AppColors.background,
  );
}