import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:litenews/res/colors.dart';
import 'package:litenews/utils/my_dialog.dart';

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

    getHtml();

    // updateTextSize(textSize);
  }

  @deprecated
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
    MyDialog.showLoading();
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'text/html; charset=gbk';
    dio.options.responseDecoder = gbkDecoder;
    Response response = await dio.get(itemId);
    String content = response.data.toString();
    dom.Document document = parse(content);
    var div = document.getElementById('postlist');
    var ss = div?.getElementsByClassName('t_fsz').first.innerHtml;

    setState(() {
      htmlData = '<div>$ss</div>';
      Log.d('htmlData=$htmlData');
      MyDialog.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.arguments.title),
      ),
      body: getHtmlWidget2(),
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
  Widget getHtmlWidget() {
    return Container(
      constraints: const BoxConstraints(minHeight: 200.0),
      child: SingleChildScrollView(
        child: Html(
          data: htmlData,
        ),
      ),
    );
  }

  Widget getHtmlWidget2() {
    return SingleChildScrollView(
      child: HtmlWidget(
        htmlData,
        // customStylesBuilder: (element) {
        //   if (element.classes.contains('container')) {
        //     return {'backgroud-color': 'red'};
        //   }
        //   return null;
        // },
      ),
    );
  }
}

class ImDetailsArguments {
  final String itemId;
  final String title;

  ImDetailsArguments({required this.itemId, required this.title});
}
