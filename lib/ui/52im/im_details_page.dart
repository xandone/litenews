import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gbk_codec/gbk_codec.dart';

import '../../utils/logger.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

const kInitialTextSize = 150;
const kTextSizePlaceholder = 'TEXT_SIZE_PLACEHOLDER';
const kTextSizeSourceJS = """
window.addEventListener('DOMContentLoaded', function(event) {
  document.body.style.textSizeAdjust = '$kTextSizePlaceholder%';
  document.body.style.webkitTextSizeAdjust = '$kTextSizePlaceholder%';
});
""";
final textSizeUserScript = UserScript(
    source:
        kTextSizeSourceJS.replaceAll(kTextSizePlaceholder, '$kInitialTextSize'),
    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START);

class ImDetailsPage extends StatefulWidget {
  ImDetailsArguments arguments;

  ImDetailsPage({super.key, required this.arguments});

  @override
  State<StatefulWidget> createState() {
    return HelloDetalsState();
  }
}

class HelloDetalsState extends State<ImDetailsPage> {
  late InAppWebViewController webViewController;
  late String itemId;
  late String htmlData;
  int textSize = kInitialTextSize;

  @override
  void initState() {
    super.initState();
    itemId = widget.arguments.itemId;
    htmlData = '';

    // getHtml();

    // updateTextSize(textSize);
  }

  updateTextSize(int textSize) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await webViewController?.setSettings(
          settings: InAppWebViewSettings(textZoom: textSize));
    } else {
      // update current text size
      await webViewController?.evaluateJavascript(source: """
              document.body.style.textSizeAdjust = '$textSize%';
              document.body.style.webkitTextSizeAdjust = '$textSize%';
            """);

      // update the User Script for the next page load
      await webViewController?.removeUserScript(userScript: textSizeUserScript);
      textSizeUserScript.source =
          kTextSizeSourceJS.replaceAll(kTextSizePlaceholder, '$textSize');
      await webViewController?.addUserScript(userScript: textSizeUserScript);
    }
  }

  String gbkDecoder(List<int> responseBytes, RequestOptions options,
      ResponseBody responseBody) {
    return gbk_bytes.decode(responseBytes);
  }

  void getHtml() async {
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'text/html; charset=gbk';
    dio.options.responseDecoder = gbkDecoder;
    Response response = await dio.get(itemId);
    String content = response.data.toString();
    dom.Document document = parse(content);
    var div = document.getElementById('postlist');
    // var ss = div
    //     ?.getElementsByClassName('t_fsz')
    //     .first
    //     .innerHtml;

    setState(() {
      htmlData = '<div>${div?.innerHtml}</div>';
      Log.d('htmlData=$htmlData');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('11111'),
        actions: [
          IconButton(
              onPressed: () async {
                textSize++;
                await updateTextSize(textSize);
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () async {
                textSize--;
                await updateTextSize(textSize);
              },
              icon: const Icon(Icons.remove)),
          TextButton(
            onPressed: () async {
              textSize = kInitialTextSize;
              await updateTextSize(textSize);
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),

      body: getWebView(),
    );
  }

  InAppWebView getWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(itemId)),
      initialUserScripts: UnmodifiableListView(
          !kIsWeb && defaultTargetPlatform == TargetPlatform.android
              ? []
              : [textSizeUserScript]),
      initialSettings: InAppWebViewSettings(textZoom: textSize),
      onWebViewCreated: (controller) async {
        webViewController = controller;
      },
    );
  }

  @deprecated
  StatefulWidget getHtmlWidget() {
    return Html(
      data: htmlData,
    );
  }
}

class ImDetailsArguments {
  final String itemId;

  ImDetailsArguments({required this.itemId});
}
