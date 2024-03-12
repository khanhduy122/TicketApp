import 'package:flutter/material.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/models/voucher.dart';
import 'package:ticket_app/screen/auth_screen/forgot_password.dart';
import 'package:ticket_app/screen/auth_screen/signin_screen.dart';
import 'package:ticket_app/screen/auth_screen/signup_screen.dart';
import 'package:ticket_app/screen/auth_screen/verify_screen.dart';
import 'package:ticket_app/screen/checkout_ticket/checkout_ticket.dart';
import 'package:ticket_app/screen/detail_movie_screen/all_review_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/detail_movie_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/play_video_trailer_screen.dart';
import 'package:ticket_app/screen/detail_ticket_screen/detail_my_ticket_screen.dart';
import 'package:ticket_app/screen/detail_ticket_screen/detaile_ticket_expired_screen.dart';
import 'package:ticket_app/screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:ticket_app/screen/main_screen/main_screen.dart';
import 'package:ticket_app/screen/payment_screen/payment_screen.dart';
import 'package:ticket_app/screen/payment_screen/payment_success_screen.dart';
import 'package:ticket_app/screen/search_screen/search_screen.dart';
import 'package:ticket_app/screen/payment_screen/select_card_screen.dart';
import 'package:ticket_app/screen/select_showtimes_movie/select_cinema_screen.dart';
import 'package:ticket_app/screen/select_showtimes_movie/select_movie_screen.dart';
import 'package:ticket_app/screen/select_seat_screen.dart/select_seat_screen.dart';
import 'package:ticket_app/screen/splash_screen/on_boarding.screen.dart';
import 'package:ticket_app/screen/splash_screen/splash_screen.dart';
import 'package:ticket_app/screen/voucher_screen/detaile_voucher_screen.dart';
import 'package:ticket_app/screen/voucher_screen/select_voucher_screen.dart';
import 'package:ticket_app/screen/voucher_screen/voucher_screen.dart';
import 'package:ticket_app/screen/write_review_screen/write_review_screen.dart';

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
    return SelectMovieScreen(
      cinema: ModalRoute.of(context)!.settings.arguments as Cinema,
    );
  },
  RouteName.selectCinemaScreen: (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return SelectCinemaScreen(
      movie: arguments["movie"],
      cinemaCity: arguments["cinemaCity"],
    );
  },
  RouteName.selectSeatScreen: (context) {
    return SelectSeatScreen(
      ticket: ModalRoute.of(context)!.settings.arguments as Ticket,
    );
  },
  RouteName.checkoutTicketScreen: (context) {
    return CheckoutTicketScreen(
        ticket: ModalRoute.of(context)!.settings.arguments as Ticket);
  },
  RouteName.detailMyTicketScreen: (context) {
    return DetailMyTicketScreen(
      ticket: ModalRoute.of(context)!.settings.arguments as Ticket,
    );
  },
  RouteName.detailTicketExpiredScreen: (context) {
    return DetailTicketExpiredScreen(
      ticket: ModalRoute.of(context)!.settings.arguments as Ticket,
    );
  },
  RouteName.searchScreen: (context) => const SearchScreen(),
  RouteName.selectCardScreen: (context) {
    Map<String, dynamic>? arguments = 
        ModalRoute.of(context)!.settings.arguments != null 
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic> : null;
    return SelectCardScreen(
      ticket: arguments != null ? arguments["ticket"] : null,
      voucher: arguments != null ?  arguments["voucher"] : null,
    );
  },
  RouteName.paymentScreen: (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return PaymentScreen(
      paymentCard: arguments["paymentCard"],
      ticket: arguments["ticket"],
    );
  },
  RouteName.paymentSuccessScreen: (context) {
    return const PaymentSuccessScreen();
  },
  RouteName.writeReviewScreen: (context) {
    return WriteReviewScreen(
      ticket: ModalRoute.of(context)!.settings.arguments as Ticket,
    );
  },
  RouteName.forgotPasswordScreen: (context) {
    return const ForgotPasswordScreen();
  },
  RouteName.voucherScreen: (context) {
    return const VoucherScreen();
  },
  RouteName.detailVoucherScreen: (context) {
    return DetailVoucherScreen(
      voucher: ModalRoute.of(context)!.settings.arguments as Voucher,
    );
  },
  RouteName.selectVoucherScreen: (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return SelectVoucherScreen(
      voucherSelected: arguments["voucherSelected"],
      cinemasType: arguments["cinemasType"],
    );
  },
};
