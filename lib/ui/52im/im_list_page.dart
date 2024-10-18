import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:litenews/res/colors.dart';
import 'package:litenews/ui/52im/im_details_page.dart';

import '../../http/api.dart';
import '../../models/im52/im_item_bean.dart';
import '../../utils/logger.dart';

class ImListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImListState();
  }
}

class ImListState extends State<ImListPage> with AutomaticKeepAliveClientMixin {
  List<ImItemBean> datas = [];

  @override
  void initState() {
    super.initState();
    getHtml();
  }

  String gbkDecoder(List<int> responseBytes, RequestOptions options,
      ResponseBody responseBody) {
    return gbk_bytes.decode(responseBytes);
  }

  void getHtml() async {
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'text/html; charset=gbk';
    dio.options.responseDecoder = gbkDecoder;
    Response response = await dio.get('${Api.IM52_PAGE}forum-103-1.html');
    String content = response.data.toString();
    dom.Document document = parse(content);

    var listRoot = document.getElementById('threadlisttableid');

    var list = listRoot?.getElementsByTagName('tr');

    Log.d('${list?.length}');

    setState(() {
      datas.clear();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: datas.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Card(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              datas[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16, color: MyColors.b1_color),
                            )),
                            Visibility(
                                visible: datas[index].comment_total > 0,
                                child: Container(
                                  height: 16,
                                  constraints: BoxConstraints(minWidth: 16),
                                  // padding: EdgeInsets.all(2),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    '${datas[index].comment_total}',
                                    style: TextStyle(
                                        color: MyColors.white, fontSize: 12),
                                  ),
                                  decoration: BoxDecoration(
                                      color: MyColors.bl3_color,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Visibility(
                                visible: datas[index].primary_lang.isNotEmpty,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(
                                    datas[index].primary_lang,
                                    style: TextStyle(
                                        color: MyColors.b2_color, fontSize: 12),
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Text(
                                datas[index].updated_at,
                                style: TextStyle(
                                    fontSize: 12, color: MyColors.b2_color),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ImDetailsPage(
                    arguments:
                        ImDetailsArguments(itemId: datas[index].item_id));
              }))
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}