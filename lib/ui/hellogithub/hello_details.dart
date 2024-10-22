import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../db/hello_box.dart';
import '../../db/hello_item_dao.dart';
import '../../db/objectbox.dart';
import '../../http/api.dart';
import '../../objectbox.g.dart';
import '../../utils/logger.dart';

class HelloDetailsPage extends StatefulWidget {
  HelloDetailsArguments arguments;

  HelloDetailsPage({super.key, required this.arguments});

  @override
  State<StatefulWidget> createState() {
    return HelloDetalsState();
  }
}

class HelloDetalsState extends State<HelloDetailsPage> {
  late InAppWebViewController inAppWebViewController;
  late String itemId;
  late String url;
  late HelloBox helloBox;
  late HelloItemDao helloItemDao;

  @override
  void initState() {
    super.initState();
    Log.d('${widget.arguments.isFromDb}');
    if (widget.arguments.isFromDb) {
      init();
    } else {
      itemId = widget.arguments.itemId;
      url = '${Api.HELLOGITHUB_PAGE}/repository/$itemId';
      Log.d('url=$url');
    }
  }

  void init() async {
    helloBox = HelloBox();
    Box<HelloItemDao> box = await ObjectBox().createBox<HelloItemDao>();
    helloBox.initBox(box);
    HelloItemDao hello = (await helloBox.readNote(widget.arguments.mId))!;
    setState(() {
      helloItemDao = hello;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: getWebView(),
      ),
    );
  }

  Widget getWebView() {
    if (widget.arguments.isFromDb) {
      return InAppWebView(
        initialData: InAppWebViewInitialData(data: helloItemDao.local_content),
      );
    } else {
      return InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
      );
    }
  }
}

class HelloDetailsArguments {
  String itemId;
  bool isFromDb;
  int mId;

  HelloDetailsArguments(
      {required this.itemId, this.isFromDb = false, this.mId = 0});
}
