import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

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
        Log.d(it.text);
        datas.add(it.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('datas[0]'),
    );
  }
}
