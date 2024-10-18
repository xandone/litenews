import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../http/api.dart';
import '../../utils/logger.dart';

class ImDetailsPage extends StatefulWidget {
  ImDetailsArguments arguments;

  ImDetailsPage({super.key, required this.arguments});

  @override
  State<StatefulWidget> createState() {
    return HelloDetalsState();
  }
}

class HelloDetalsState extends State<ImDetailsPage> {
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
            url: WebUri(itemId),)
      )
    );
  }
}

class ImDetailsArguments {
  final String itemId;

  ImDetailsArguments({required this.itemId});
}
