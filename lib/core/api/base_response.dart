import 'package:ticket_app/core/api/app_faild.dart';

class BaseResponse {
  dynamic data;
  AppFailure? error;

  BaseResponse({this.data, this.error});
}
