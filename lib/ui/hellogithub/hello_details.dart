import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../http/api.dart';
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

  @override
  void initState() {
    super.initState();
    itemId = widget.arguments.itemId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
            url: WebUri('${Api.HELLOGITHUB_PAGE}/repository/$itemId')),
      ),
    );
  }
}

class HelloDetailsArguments {
  final String itemId;

  HelloDetailsArguments({required this.itemId});
}
