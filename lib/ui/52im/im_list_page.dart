import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:litenews/res/colors.dart';

import '../../http/api.dart';
import '../../utils/logger.dart';

class ImListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImListState();
  }
}

class ImListState extends State<ImListPage> {
  List<String> datas = [];

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
    Log.d(content);
    dom.Document document = parse(content);

    var list = document
        .getElementById('threadlisttableid')
        ?.getElementsByClassName('s xst');

    setState(() {
      list?.forEach((it) {
        datas.clear();
        Log.d(it.text);
        datas.add(it.text);
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
              child: Padding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      datas[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: MyColors.b1_color),
                    ),
                    Text('data'),
                  ],
                ),
                padding: EdgeInsets.all(12),
              ),
            ),
          );
        },
      ),
    );
  }
}
