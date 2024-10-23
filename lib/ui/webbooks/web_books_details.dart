import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:litenews/db/objectbox.dart';

import '../../db/web_book_dao.dart';
import '../../db/webbook_box.dart';
import '../../http/api.dart';
import '../../objectbox.g.dart';
import '../../utils/logger.dart';

class WebBooksDetails extends StatefulWidget {
  WebBooksArguments arguments;

  WebBooksDetails({super.key, required this.arguments});

  @override
  State<StatefulWidget> createState() {
    return HelloDetalsState();
  }
}

class HelloDetalsState extends State<WebBooksDetails> {
  String currentUrl = "";
  late WebbookBox webbookBox;

  @override
  void initState() {
    super.initState();
    currentUrl = widget.arguments.currentUrl;
    init();
  }

  @override
  void dispose() {
    super.dispose();

    if (currentUrl.isNotEmpty) {
      saveDb();
    }
  }

  void init() async {
    webbookBox = WebbookBox();
    Box<WebBookDao> box = await ObjectBox().createBox<WebBookDao>();
    webbookBox.initBox(box);
  }

  void saveDb() async {
    webbookBox.addNote(
        WebBookDao(item_id: widget.arguments.itemId, current_url: currentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
            initialUrlRequest: URLRequest(
                url: WebUri(widget.arguments.currentUrl.isEmpty
                    ? widget.arguments.itemId
                    : widget.arguments.currentUrl)),
            onWebViewCreated: (controller) async {
            },
            onUpdateVisitedHistory: (controller, url, isReload) {
              currentUrl = url!.uriValue.toString();
              Log.d('currentUrl=$currentUrl');
            }),
      ),
    );
  }
}

class WebBooksArguments {
  String itemId;
  String currentUrl;

  WebBooksArguments({required this.itemId, this.currentUrl = ''});
}
