import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../http/api.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.arguments.itemId)),
        ),
      ),
    );
  }
}

class WebBooksArguments {
  String itemId;

  WebBooksArguments({required this.itemId});
}
