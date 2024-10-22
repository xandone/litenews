import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:litenews/res/colors.dart';

class MyDialog {
  static void showAttachDialog(BuildContext context, String title) {
    SmartDialog.showAttach(
      targetContext: context,
      alignment: Alignment.bottomCenter,
      animationType: SmartAnimationType.scale,
      highlightBuilder: (_, __) {
        return Positioned(child: Container());
      },
      scalePointBuilder: (selfSize) => Offset(selfSize.width, 0),
      builder: (_) {
        return Container(
          height: 50,
          width: 30,
          color: MyColors.bl3_color,
          child: Text(title),
        );
      },
    );
  }

  static void showLoading() {
    SmartDialog.showLoading(msg: "加载中");
  }

  static void dismiss() {
    SmartDialog.dismiss();
  }
}
