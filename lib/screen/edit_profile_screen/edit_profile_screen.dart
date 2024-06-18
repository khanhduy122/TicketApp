import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_confirm.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/moduels/user/user_bloc.dart';
import 'package:ticket_app/moduels/user/user_event.dart';
import 'package:ticket_app/moduels/user/user_state.dart';
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
  User? user;
  late final UserBloc userBloc;
  String userName = "";
  File? imageSelected;
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    user = FirebaseAuth.instance.currentUser!;
    userName = user!.displayName ?? "";
    emailController.text = user!.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: userBloc,
      listener: (context, state) {
        _onListener(state);
      },
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          _onWillPop();
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: ButtonBackWidget(
                        onTap: () => _onBackScreen(),
                      )),
                  _buildAvatar(context),
                  SizedBox(
                    height: 20.h,
                  ),
                  _buildTextFieldName(),
                  SizedBox(
                    height: 20.h,
                  ),
                  _buildTextFieldEmail(),
                  SizedBox(
                    height: 40.h,
                  ),
                  _buildButtonSave(),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ButtonWidget _buildButtonSave() {
    return ButtonWidget(
        title: "Cập Nhật",
        height: 60.h,
        width: 250.w,
        color: (userName.trim() != user!.displayName!.trim() ||
                imageSelected != null)
            ? AppColors.buttonColor
            : AppColors.darkBackground,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            userBloc.add(
                EditProfileUserEvent(name: userName, photo: imageSelected));
          }
        });
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: emailController,
      readOnly: true,
      style: AppStyle.defaultStyle.copyWith(color: Colors.grey[700]),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade700)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade700)),
      ),
    );
  }

  Widget _buildTextFieldName() {
    return Form(
      key: formKey,
      child: TextFormFieldWidget(
        label: "Họ Và Tên",
        initValue: userName,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Vui lòng nhập tên của bạn";
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            userName = value;
          });
        },
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTapSelectPhoto(),
      child: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Stack(
          children: [
            Center(
                child: imageSelected != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(45.h),
                        child: Image.file(
                          imageSelected!,
                          fit: BoxFit.cover,
                          height: 90.h,
                          width: 90.w,
                        ),
                      )
                    : (user!.photoURL == null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(45.h),
                            child: SizedBox(
                                height: 90.h,
                                width: 90.w,
                                child: Image.asset(
                                  AppAssets.imgAvatarDefault,
                                  fit: BoxFit.fill,
                                )),
                          )
                        : ImageNetworkWidget(
                            url: user!.photoURL!,
                            height: 90.h,
                            width: 90.w,
                            borderRadius: 45.h,
                          )),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: SizedBox(
                  height: 25.h,
                  width: 25.w,
                  child: Image.asset(
                    AppAssets.icAdd,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onTapSelectPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          imageSelected = File(image.path);
        });
      }
    } catch (e) {
      debugLog(e.toString());
    }
  }

  Future<void> _onBackScreen() async {
    if (userName.trim() != user!.displayName!.trim() || imageSelected != null) {
      await DialogConfirm.show(
              context: context, message: "Bạn có chắc muốn hủy thay đổi ?")
          .then((isConfirm) {
        if (isConfirm) {
          Navigator.popUntil(
            context,
            (route) => route.settings.name == RouteName.mainScreen,
          );
        }
      });
    } else {
      debugLog('aaa');
      Navigator.pop(context);
    }
  }

  Future<void> _onWillPop() async {
    if (userName.trim() != user!.displayName!.trim() || imageSelected != null) {
      await DialogConfirm.show(
              context: context, message: "Bạn có chắc muốn hủy thay đổi ?")
          .then((isConfirm) {
        if (isConfirm) {
          Navigator.pop(context);
        }
      });
    }
  }

  void _onListener(Object? state) {
    if (state is EditProfileUserState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }

      if (state.user != null) {
        Navigator.popUntil(
            context, (route) => route.settings.name == RouteName.mainScreen);
      }

      if (state.error != null) {
        if (state.error is NoInternetException) {
          DialogError.show(
              context: context,
              message: "Không có kết nối internet, vui lòng kiểm tra lại!");
          return;
        }

        DialogError.show(
            context: context, message: "Đã Có lỗi xảy ra vui lòng thử lại!");
      }
    }
  }
}
