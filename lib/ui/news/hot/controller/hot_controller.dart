import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../../../../http/api.dart';
import '../../../../http/http_dio.dart';
import '../../../../models/hot/hot_bean.dart';

/// @author: xiao
/// created on: 2025/3/7 16:47
/// description:

class HotController extends GetxController {
  RxList<HotBean> datas = RxList();
  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: false,
  );

  void getList() async {
    Map<String, dynamic> params = Map();
    params['id'] = 'toutiao';
    var result = await MyHttp.instance
        .get('api/s', baseUrl: Api.NEWSNOW_BUSIYI, queryParameters: params);

    refreshController.finishRefresh();
    datas.clear();

    for (var item in result['items']) {
      datas.add(HotBean.fromJson(item));
    }

  }
}
