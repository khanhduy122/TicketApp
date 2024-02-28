import 'dart:io';

import 'package:ticket_app/models/ticket.dart';

abstract class ReviewEvent{}

class GetInitReviewMovieEvent extends ReviewEvent {
  String id;
  int rating;

  GetInitReviewMovieEvent({required this.id, required this.rating});
}

class LoadMoreReviewMovieEvent extends ReviewEvent {
  String id;
  int rating;

  LoadMoreReviewMovieEvent({required this.id, required this.rating});
}

class AddReviewEvent extends ReviewEvent{
  final String? contentReview;
  final int rating;
  final List<File>? images;
  final Ticket ticket;

  AddReviewEvent({this.contentReview,required this.rating, this.images, required this.ticket});
}
