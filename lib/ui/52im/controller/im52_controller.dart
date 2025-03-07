import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../http/api.dart';
import '../../../models/im52/im_item_bean.dart';
import '../../../utils/logger.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

/// @author: xiao
/// created on: 2025/3/7 9:56
/// description:

class Im52Controller extends GetxController {
  RxList<ImItemBean> datas = RxList();
  int pageIndex = 1;
  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  void getList(bool isMore) async {
    if (isMore) {
      pageIndex++;
    }
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'text/html; charset=gbk';
    dio.options.responseDecoder = gbkDecoder;
    String url = '${Api.IM52_PAGE}forum-103-$pageIndex.html';
    Log.d('url=$url');
    Response response = await dio.get(url);
    String content = response.data.toString();
    dom.Document document = parse(content);

    var listRoot = document.getElementById('threadlisttableid');

    var list = listRoot?.getElementsByTagName('tr');

    Log.d('${list?.length}');

    if (!isMore) {
      refreshController.finishRefresh();
      refreshController.resetFooter();
      datas.clear();
    }
    list
        ?.where((it) => it.getElementsByClassName('xi2').isNotEmpty)
        .forEach((it) {
      String comment_total = it.getElementsByClassName('xi2').first.text;
      String item_id =
          it.getElementsByClassName('s xst').first.attributes['href']!;

      String primary_lang;
      if (it.getElementsByTagName('font').isEmpty) {
        primary_lang = '';
      } else {
        primary_lang = it.getElementsByTagName('font').first.text;
      }

      String title = it.getElementsByClassName('s xst').first.text;
      String updated_at =
          it.getElementsByClassName('js_flist_lastpost').first.text;
      datas.add(ImItemBean(
          comment_total: int.parse(comment_total),
          item_id: item_id,
          primary_lang: primary_lang,
          title: title,
          updated_at: updated_at));
    });

    refreshController.finishLoad(
        list!.isNotEmpty ? IndicatorResult.success : IndicatorResult.noMore);
  }

  String gbkDecoder(List<int> responseBytes, RequestOptions options,
      ResponseBody responseBody) {
    return gbk_bytes.decode(responseBytes);
  }
}
