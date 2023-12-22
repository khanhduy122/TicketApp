import 'package:flutter/material.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/screen/auth_screen/screens/signin_screen.dart';
import 'package:ticket_app/screen/auth_screen/screens/signup_screen.dart';
import 'package:ticket_app/screen/auth_screen/screens/verify_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/all_review_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/detail_movie_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/play_video_trailer_screen.dart';
import 'package:ticket_app/screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:ticket_app/screen/main_screen/main_screen.dart';
import 'package:ticket_app/screen/select_filter_movie/select_cinema_screen.dart';
import 'package:ticket_app/screen/select_filter_movie/select_movie_screen.dart';
import 'package:ticket_app/screen/splash_screen/on_boarding.screen.dart';
import 'package:ticket_app/screen/splash_screen/splash_screen.dart';

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
  RouteName.editProfileScreen: (context) => const EditProfileScreen(),
  RouteName.detailMovieScreen: (context) {
    return DetailMovieScreen(
      movie: ModalRoute.of(context)!.settings.arguments as Movie,
    );
  },
  RouteName.playVideoTrailerScreen: (context) {
    return PlayVideoTrailerScreen(
      movie: ModalRoute.of(context)!.settings.arguments as Movie,
    );
  },
  RouteName.allReviewScreen: (context) {
    return AllReviewScreen(
      movie: ModalRoute.of(context)!.settings.arguments as Movie,
    );
  },
  RouteName.selectMovieScreen: (context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return SelectMovieScreen(
      cinema: arguments["cinema"],
      cityName: arguments["cityName"],
    );
  },
  RouteName.selectCinemaScreen: (context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return SelectCinemaScreen(
      movie: arguments["movie"],
      cinemaCity: arguments["cinemaCity"],
    );
  },
};