import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_key.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/screen/splash_screen/bloc/get_data_app_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final GetDataAppBloc getDataAppBloc = GetDataAppBloc();

  @override
  void initState() {
    super.initState();
    getDataAppBloc.add(GetDataAppEvent());
  }

  @override
  Widget build(BuildContext context) { 

    return BlocListener(
      bloc: getDataAppBloc,
      listenWhen: (previous, current) {
        return current is GetDataAppState;
      },
      listener: (_, state) async {
        _listenerSplash(state, context, checkIsFirst);
      },
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: 120.h,
            width: 120.w,
            child: Image.asset(AppAssets.imgLogo, fit: BoxFit.fill,),
          ),
        ),
      ),
    );
  }

  void _listenerSplash(Object? state, BuildContext context, Future<void> Function(BuildContext context) checkIsFirst) {
    if(state is GetDataAppState){
      if(state.homeData != null && state.cinemasRecommended != null){
        context.read<DataAppProvider>().setData(homeData: state.homeData, reconmmedCinemas:state.cinemasRecommended);
        checkIsFirst(context);
      }
    }
  }

  Future<void> checkIsFirst(BuildContext context) async{
    if(FirebaseAuth.instance.currentUser != null){
      context.read<DataAppProvider>().user!.reload();
      Navigator.pushNamedAndRemoveUntil(context, RouteName.mainScreen, (route) => false);
    }else{
      await SharedPreferences.getInstance().then((prefs) {
        if(prefs.getBool(AppKey.checkIsFirstKey) == null){
          prefs.setBool(AppKey.checkIsFirstKey, true);
          Navigator.pushNamedAndRemoveUntil(context, RouteName.onBoardingScreen, (route) => false);
        }else{
          Navigator.pushNamedAndRemoveUntil(context, RouteName.signInScreen, (route) => false);
        }
      });
    }
  }

}