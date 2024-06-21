import 'package:ticket_app/components/api/app_faild.dart';

class BaseResponse {
  Map<String, dynamic>? data;
  AppFailure? error;

  BaseResponse({this.data, this.error});
}
