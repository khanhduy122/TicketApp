class ApiConst {
  static const String baseUrl = 'http://127.0.0.1:8080';
  static const homeUrl = '$baseUrl/home';
  static const cinemaCityUrl = '$baseUrl/cinemaCity';
  static const allReview = '$baseUrl/review';
  static const getMovieShowingInCinema = '$baseUrl/showtimes/cinema';
  static const getCinemaShowingMovie = '$baseUrl/showtimes/movie';
  static const getListSeat = '$baseUrl/seat/list_seat';
  static const keepSeat = '$baseUrl/seat/keep_seat';
  static const cancelSeat = '$baseUrl/seat/cancel_seat';
  static const signUp = '$baseUrl/user/sign_up';
  static const signIn = '$baseUrl/user/sign_in';
  static const editProfile = '$baseUrl/user/edit_profile';
  static const addPaymentCard = '$baseUrl/user/add_payment_card';
}
