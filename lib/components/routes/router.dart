import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/models/voucher.dart';
import 'package:ticket_app/screen/forgot_password/forgot_password_binding.dart';
import 'package:ticket_app/screen/forgot_password/forgot_password_screen.dart';
import 'package:ticket_app/screen/main_screen/main_screen.dart';
import 'package:ticket_app/screen/sign/signin_binding.dart';
import 'package:ticket_app/screen/sign/signin_screen.dart';
import 'package:ticket_app/screen/signup/signup_binding.dart';
import 'package:ticket_app/screen/signup/signup_screen.dart';
import 'package:ticket_app/screen/verify_email/verify_email_binding.dart';
import 'package:ticket_app/screen/verify_email/verify_email_screen.dart';
import 'package:ticket_app/screen/checkout_ticket/checkout_ticket.dart';
import 'package:ticket_app/screen/detail_movie_screen/all_review_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/detail_movie_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/open_image_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/play_video_trailer_screen.dart';
import 'package:ticket_app/screen/detail_ticket_screen/detail_my_ticket_screen.dart';
import 'package:ticket_app/screen/detail_ticket_screen/detaile_ticket_expired_screen.dart';
import 'package:ticket_app/screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:ticket_app/screen/onboarding/on_boarding.screen.dart';
import 'package:ticket_app/screen/splash_screen/splash_binding.dart';
import 'package:ticket_app/screen/splash_screen/splash_screen.dart';

class AppRoutes {
  static const INITPAGE = RouteName.splashScreen;
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: RouteName.splashScreen,
      page: SplashScreen.new,
      binding: SplashBinding(),
    ),
    GetPage(
      name: RouteName.onBoardingScreen,
      page: OnBoardingScreen.new,
    ),
    GetPage(
      name: RouteName.signInScreen,
      page: SignInScreen.new,
      binding: SigninBinding(),
    ),
    GetPage(
      name: RouteName.signUpScreen,
      page: SignUpScreen.new,
      binding: SignupBinding(),
    ),
    GetPage(
      name: RouteName.forgotPasswordScreen,
      page: ForgotPasswordScreen.new,
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: RouteName.verifyScreen,
      page: VerifyEmailScreen.new,
      binding: VerifyEmailBinding(),
    ),
    GetPage(
      name: RouteName.mainScreen,
      page: MainScreen.new,
      binding: SplashBinding(),
    )
  ];
}
