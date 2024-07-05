import 'package:ticket_app/components/const/app_assets.dart';

class PaymentCard {
  String? cardNumber;
  String? token;
  String? nameBank;

  PaymentCard(
      {required this.cardNumber, required this.nameBank, required this.token});

  PaymentCard.fromJson(Map<String, dynamic> json) {
    cardNumber = json["cardNumber"];
    token = json["token"];
    nameBank = json["nameBank"];
  }

  PaymentCard.fromVnpParam(Map<String, dynamic> json) {
    cardNumber = json["vnp_card_number"];
    token = json["vnp_token"];
    nameBank = json["vnp_bank_code"];
  }

  Map<String, dynamic> toJson() {
    return {
      "cardNumber": cardNumber,
      "token": token,
      "nameBank": nameBank,
    };
  }

  String getLogoCard() {
    switch (nameBank) {
      case "NCB":
        return AppAssets.icNCB;
    }

    return "";
  }
}
