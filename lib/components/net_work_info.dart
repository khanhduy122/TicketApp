import 'dart:io';

class NetWorkInfo {
  static Future<bool> isConnectedToInternet({String? lookUpAddress}) async {
    try {
      lookUpAddress ??= 'www.google.com';
      final result = await InternetAddress.lookup(lookUpAddress);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }
}