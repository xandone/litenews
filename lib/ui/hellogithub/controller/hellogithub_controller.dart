import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:litenews/models/hellogithub/hello_item_bean.dart';

import '../../../http/api.dart';
import '../../../http/http_dio.dart';

/// @author: xiao
/// created on: 2025/3/7 9:56
/// description:

class HellogithubController extends GetxController {
  RxList<HelloItemBean> datas = RxList();
  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  void getList(bool isMore) async {
    int page = isMore ? datas.length ~/ 10 : 0;
    page = page + 1;

    Map<String, dynamic> params = Map();
    params['page'] = page;
    params['sort_by'] = 'featured';
    params['rank_by'] = 'newest';
    params['tid'] = 'all';

    var result = await MyHttp.instance
        .get('v1/', baseUrl: Api.HELLOGITHUB_API, queryParameters: params);

    if (!isMore) {
      refreshController.finishRefresh();
      refreshController.resetFooter();
      datas.clear();
    }
    for (var item in result['data']) {
      datas.add(HelloItemBean.fromJson(item));
    }

    refreshController.finishLoad(
        result['has_more'] ? IndicatorResult.success : IndicatorResult.noMore);
  }
}
