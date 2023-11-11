import 'package:flutter/material.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/screen/auth/screens/signin_screen.dart';
import 'package:ticket_app/screen/auth/screens/signup_screen.dart';
import 'package:ticket_app/screen/auth/screens/verify_screen.dart';
import 'package:ticket_app/screen/main/main_screen.dart';
import 'package:ticket_app/screen/splash/on_boarding.screen.dart';
import 'package:ticket_app/screen/splash/splash_screen.dart';

Map<String, WidgetBuilder> routes = {
  RouteName.splashScreen: (context) => const SplashScreen(),
  RouteName.onBoardingScreen: (context) => const OnBoardingScreen(),
  RouteName.signInScreen: (context) => const SignInScreen(),
  RouteName.signUpScreen: (context) => const SignUpScreen(),
  RouteName.verifyScreen: (context) {
    return VerifyScreen(
      email: ModalRoute.of(context)!.settings.arguments as String,
    );
  },
  RouteName.mainScreen: (context) => const MainScreen(),
};