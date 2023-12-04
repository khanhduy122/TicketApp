import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/widgets/button_back_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/text_from_field_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

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
        child: Column(
          children: [
            SizedBox(height: 40.h,),
            const Align(
              alignment: Alignment.centerLeft,
              child: ButtonBackWidget()
            ),
            SizedBox(
              height: 100.h,
              width: 100.w,
              child: Stack(
                children: [
                  Center(
                    child: user.photoURL == null ? ClipRRect(
                      borderRadius: BorderRadius.circular(45.h),
                      child: SizedBox(
                        height: 90.h,
                        width: 90.w,
                        child: Image.asset(AppAssets.imgAvatarDefault, fit: BoxFit.fill,)
                      ),
                    ) : ImageNetworkWidget(
                      url: context.read<DataAppProvider>().user!.photoURL!, 
                      height: 90.h, 
                      width: 90.w,
                      borderRadius: 45.h,
                    )
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: SizedBox(
                        height: 25.h,
                        width: 25.w,
                        child: Image.asset(AppAssets.icAdd, fit: BoxFit.fill,),
                      ),
                    ),
                  )
                ],
              ),
            ),
      
            SizedBox(height: 20.h,),
            TextFormFieldWidget(
              label: "Họ Và Tên", 
              initValue: user.displayName,
              textInputAction: TextInputAction.next,
              validator: (value) {
                
              },
              
            ),
      
            SizedBox(height: 20.h,),
            TextFormFieldWidget(
              label: "Địa Chỉ Email", 
              initValue: user.email,
              textInputAction: TextInputAction.next,
              validator: (value) {
              },
            ),
      
            SizedBox(height: 40.h,),
            ButtonWidget(
              title: "Cập Nhật", 
              height: 60.h, 
              width: 250.w, 
              onPressed: (){
                
              }
            ),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }
}