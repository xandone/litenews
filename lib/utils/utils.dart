import 'package:flutter/cupertino.dart';


class Utils {

  static void hideSoftInput(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
