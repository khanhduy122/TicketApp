import 'package:intl/intl.dart';

class DateTimeUtil {
  static String stringFromDateTime(DateTime dateTime) {
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }

  static DateTime stringToDateTime(String date) {
    return DateFormat('dd/MM/yyyy').parse(date);
  }
}
