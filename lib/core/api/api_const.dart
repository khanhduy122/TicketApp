class ApiConst {
  static const String baseUrl = 'http://127.0.0.1:8080';
  static const homeUrl = '$baseUrl/home';
  static const cinemaCityUrl = '$baseUrl/cinema';
  static const allReview = '$baseUrl/review';
  static const addReview = '$baseUrl/review/add_review';
  static const getMovieShowingInCinema = '$baseUrl/showtimes/cinema';
  static const getCinemaShowingMovie = '$baseUrl/showtimes/movie';
  static const getListSeat = '$baseUrl/seat/list_seat';
  static const keepSeat = '$baseUrl/seat/keep_seat';
  static const cancelSeat = '$baseUrl/seat/cancel_seat';
  static const bookSeat = '$baseUrl/seat/book_seat';
  static const checkSeat = '$baseUrl/seat/check_seat';
  static const signUp = '$baseUrl/user/sign_up';
  static const signIn = '$baseUrl/user/sign_in';
  static const editProfile = '$baseUrl/user/edit_profile';
  static const addPaymentCard = '$baseUrl/user/add_payment_card';
  static const deleteCard = '$baseUrl/user/delete_payment_card';
  static const getListTicket = '$baseUrl/ticket/get_list_ticket';
  static const getTicketPrices = '$baseUrl/cinema/ticket_price';
}
