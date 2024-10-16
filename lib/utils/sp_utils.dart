import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static late final SharedPreferences prefs;

  static Future<SharedPreferences> init() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}
