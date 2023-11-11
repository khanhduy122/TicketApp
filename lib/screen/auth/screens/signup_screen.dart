import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/screen/auth/blocs/auth_bloc.dart';
import 'package:ticket_app/screen/auth/blocs/auth_event.dart';
import 'package:ticket_app/screen/auth/blocs/auth_exception.dart';
import 'package:ticket_app/screen/auth/blocs/auth_state.dart';
import 'package:ticket_app/widgets/button_back_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/text_from_field_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formSignUpKey  = GlobalKey<FormState>();
  late final AuthBloc _signUpBloc;

  @override
  void initState() {
    super.initState();
    _signUpBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: _signUpBloc,
        listenWhen: (previous, current) {
          return current is SignUpState;
        },
        listener: (context, state) {
          _onListenerSignUp(state, context);
        },
        child: SafeArea(
          child: Form(
            key: _formSignUpKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        const ButtonBackWidget(),
                        Expanded(child: Text("Create New\nYour Account", style: AppStyle.titleStyle, textAlign: TextAlign.center,)),
                      ],
                    ),
                    SizedBox(height: 40.h,),
                    SizedBox(
                      height: 100.h,
                      width: 100.w,
                      child: Stack(
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45.h),
                              child: SizedBox(
                                height: 90.h,
                                width: 90.w,
                                child: Image.asset(AppAssets.imgAvatarDefault, fit: BoxFit.fill,)
                              ),
                            ),
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
                      controller: _fullNameController,
                      label: "Full Name", 
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "Vui lòng nhập thông tin";
                        }
                        return null;
                      },
                      
                    ),
              
                    SizedBox(height: 20.h,),
                    TextFormFieldWidget(
                      controller: _emailController,
                      label: "Email Adress", 
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "Vui lòng nhập thông tin";
                        }else{
                          final bool emailValid = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value);
                          if(!emailValid){
                            return "Email không hợp lệ";
                          }
                        }
                        return null;
                      },
                    ),
              
                    SizedBox(height: 20.h,),
                    TextFormFieldWidget(
                      controller: _passwordController,
                      obscureText: true,
                      label: "Password", 
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "Vui lòng nhập thông tin";
                        }else{
                          if(value.length < 6){
                            return "Mật khẩu phải lớn hơn 6 kí tự";
                          }
                        }
                        return null;
                      },
                    ),
              
                    SizedBox(height: 20.h,),
                    TextFormFieldWidget(
                      label: "Confirm Password", 
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "Vui lòng nhập thông tin";
                        }else{
                          if(_passwordController.text != value){
                            return "Mật khẩu không trùng khớp";
                          }
                        }
                        return null;
                      },
                    ),
              
                    SizedBox(height: 40.h,),
                    ButtonWidget(
                      title: "Sign Up", 
                      height: 60.h, 
                      width: 250.w, 
                      onPressed: (){
                        if(_formSignUpKey.currentState!.validate()){
                          _signUpBloc.add(SignUpEvent(fullName: _fullNameController.text, email: _emailController.text, password: _passwordController.text));
                        }
                      }
                    ),
                    SizedBox(height: 20.h,),
              
                  ], 
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onListenerSignUp(Object? state, BuildContext context) {
    if(state is SignUpState){
      if(state.isLoading == true){
        DialogLoading.show(context);
      }
    
      if(state.signUpSucces == true){
        Navigator.pushNamedAndRemoveUntil(
          context, 
          RouteName.verifyScreen, 
          (route) => route.settings.name == RouteName.signInScreen,
          arguments: _emailController.text
        );
      }
    
      if(state.error != null){
        Navigator.pop(context);
        if(state.error is TimeOutException){
          DialogError.show(context, "Đã có lỗi xảy ra, vui lòng thử lại sao");
        }else{
          if(state.error is AccountAlreadyExistsException){
            DialogError.show(context, "Email đã tồn tại, vui lòng thử lại");
          }else{
            if(state.error is WeakPasswordException){
              DialogError.show(context, "Mật khẩu không đủ mạnh, hãy thử lại");
            }else{
              DialogError.show(context, "Đã có lỗi xảy ra, vui lòng thử lại sao");
            }
          }
        }
      }
    }
  }
}