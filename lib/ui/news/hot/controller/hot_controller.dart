import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../../../../http/api.dart';
import '../../../../http/http_dio.dart';
import '../../../../models/hellogithub/hello_item_bean.dart';

/// @author: xiao
/// created on: 2025/3/7 16:47
/// description:

class HotController extends GetxController {
  RxList<HelloItemBean> datas = RxList();
  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: false,
  );

  void getList() async {
    Map<String, dynamic> params = Map();
    params['id'] = 'coolapk';
    var result = await MyHttp.instance
        .get('api/s/', baseUrl: Api.NEWSNOW_BUSIYI, queryParameters: params);

    refreshController.finishRefresh();
    datas.clear();

    for (var item in result['data']) {
      datas.add(HelloItemBean.fromJson(item));
    }

  }
}
