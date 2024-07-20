import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/payment_card.dart';
part 'user_info_model.g.dart';

@JsonSerializable()
class UserInfoModel {
  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
  final String birthDay;
  List<PaymentCard> paymentCards;

  UserInfoModel(
      {required this.uid,
      required this.birthDay,
      required this.displayName,
      required this.email,
      required this.photoUrl,
      required this.paymentCards});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}
