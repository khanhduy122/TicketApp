import 'package:get/get.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/screen/checkout_ticket/checkout_ticket_binding.dart';
import 'package:ticket_app/screen/detail_movie_screen/all_review/all_review_binding.dart';
import 'package:ticket_app/screen/detail_movie_screen/all_review/open_image_review_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/detail_movie/detail_movie_binding.dart';
import 'package:ticket_app/screen/edit_profile_screen/edit_profile_binding.dart';
import 'package:ticket_app/screen/forgot_password/forgot_password_binding.dart';
import 'package:ticket_app/screen/forgot_password/forgot_password_screen.dart';
import 'package:ticket_app/screen/main_screen/choose_cinema/choose_cinema_binding.dart';
import 'package:ticket_app/screen/main_screen/main_screen.dart';
import 'package:ticket_app/screen/main_screen/profile/profile_binding.dart';
import 'package:ticket_app/screen/main_screen/ticket/my_ticket_binding.dart';
import 'package:ticket_app/screen/payment_screen/payment_success_screen.dart';
import 'package:ticket_app/screen/search_screen/search_screen.dart';
import 'package:ticket_app/screen/select_card/select_card_binding.dart';
import 'package:ticket_app/screen/select_card/select_card_screen.dart';
import 'package:ticket_app/screen/select_cinema/select_cinema_binding.dart';
import 'package:ticket_app/screen/select_cinema/select_cinema_screen.dart';
import 'package:ticket_app/screen/select_food/select_food_binding.dart';
import 'package:ticket_app/screen/select_food/select_food_screen.dart';
import 'package:ticket_app/screen/select_movie/select_movie_binding.dart';
import 'package:ticket_app/screen/select_movie/select_movie_screen.dart';
import 'package:ticket_app/screen/select_seat.dart/select_seat_binding.dart';
import 'package:ticket_app/screen/select_seat.dart/select_seat_screen.dart';
import 'package:ticket_app/screen/select_voucher/select_voucher_binding.dart';
import 'package:ticket_app/screen/select_voucher/select_voucher_screen.dart';
import 'package:ticket_app/screen/sign_in/signin_binding.dart';
import 'package:ticket_app/screen/sign_in/signin_screen.dart';
import 'package:ticket_app/screen/sign_up/signup_binding.dart';
import 'package:ticket_app/screen/sign_up/signup_screen.dart';
import 'package:ticket_app/screen/verify_email/verify_email_binding.dart';
import 'package:ticket_app/screen/verify_email/verify_email_screen.dart';
import 'package:ticket_app/screen/checkout_ticket/checkout_ticket_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/all_review/all_review_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/detail_movie/detail_movie_screen.dart';
import 'package:ticket_app/screen/detail_movie_screen/play_video_trailer_screen.dart';
import 'package:ticket_app/screen/detail_ticket_screen/detail_my_ticket_screen.dart';
import 'package:ticket_app/screen/detail_ticket_screen/detaile_ticket_expired_screen.dart';
import 'package:ticket_app/screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:ticket_app/screen/splash_screen/splash_binding.dart';
import 'package:ticket_app/screen/splash_screen/splash_screen.dart';
import 'package:ticket_app/screen/voucher_screen/detaile_voucher_screen.dart';
import 'package:ticket_app/screen/write_review_screen/write_review_binding.dart';
import 'package:ticket_app/screen/write_review_screen/write_review_screen.dart';

class AppRoutes {
  static const INITPAGE = RouteName.splashScreen;
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: RouteName.splashScreen,
      page: SplashScreen.new,
      binding: SplashBinding(),
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
      bindings: [
        ChooseCinemaBinding(),
        ProfileBinding(),
        MyTicketBinding(),
      ],
    ),
    GetPage(
      name: RouteName.editProfileScreen,
      page: EditProfileScreen.new,
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: RouteName.detailMovieScreen,
      page: DetailMovieScreen.new,
      binding: DetailMovieBinding(),
    ),
    GetPage(
      name: RouteName.allReviewScreen,
      page: AllReviewScreen.new,
      binding: AllReviewBinding(),
    ),
    GetPage(
      name: RouteName.playVideoTrailerScreen,
      page: () {
        return PlayVideoTrailerScreen(
          movie: Get.arguments,
        );
      },
    ),
    GetPage(
      name: RouteName.selectMovieScreen,
      page: SelectMovieScreen.new,
      binding: SelectMovieBinding(),
    ),
    GetPage(
      name: RouteName.selectCinemaScreen,
      page: SelectCinemaScreen.new,
      binding: SelectCinemaBinding(),
    ),
    GetPage(
      name: RouteName.selectSeatScreen,
      page: SelectSeatScreen.new,
      binding: SelectSeatBinding(),
    ),
    GetPage(
      name: RouteName.checkoutTicketScreen,
      page: CheckoutTicketScreen.new,
      binding: CheckoutTicketBinding(),
    ),
    GetPage(
      name: RouteName.selectCardScreen,
      page: SelectCardScreen.new,
      binding: SelectCardBinding(),
    ),
    GetPage(
      name: RouteName.searchScreen,
      page: SearchScreen.new,
    ),
    GetPage(
      name: RouteName.paymentSuccessScreen,
      page: PaymentSuccessScreen.new,
    ),
    GetPage(
      name: RouteName.detailMyTicketScreen,
      page: DetailMyTicketScreen.new,
    ),
    GetPage(
      name: RouteName.detailTicketExpiredScreen,
      page: DetailTicketExpiredScreen.new,
    ),
    GetPage(
      name: RouteName.writeReviewScreen,
      page: WriteReviewScreen.new,
      binding: WriteReviewBinding(),
    ),
    GetPage(
      name: RouteName.selectFoodScreen,
      page: SelectFoodScreen.new,
      binding: SelectFoodBinding(),
    ),
    GetPage(
      name: RouteName.selectVoucherScreen,
      page: SelectVoucherScreen.new,
      binding: SelectVoucherBinding(),
    ),
    GetPage(
      name: RouteName.detailVoucherScreen,
      page: DetailVoucherScreen.new,
    ),
    GetPage(
      name: RouteName.openImageReview,
      page: () {
        return OpenImageReviewScreen(
          images: Get.arguments['images'] as List<String>,
          index: Get.arguments['index'] as int,
        );
      },
    ),
  ];
}
