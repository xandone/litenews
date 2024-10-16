import 'package:intl/intl.dart';

class MyDateUtils {
  static DateFormat dateFormatDefault = DateFormat("yyyy-MM-dd HH:mm:ss");

  static String formatDefult(DateTime? date) {
    if (date == null) {
      return "";
    }
    return dateFormatDefault.format(date);
  }
}
