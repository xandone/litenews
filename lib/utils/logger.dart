import 'package:logger/logger.dart';

class Log {
  static Logger logger = Logger();

  static void d(String message) {
    logger.d(message);
  }
  static void i(String message) {
    logger.d(message);
  }

  static void e(String message, StackTrace stackTrace) {
    logger.d(message);
  }
}
