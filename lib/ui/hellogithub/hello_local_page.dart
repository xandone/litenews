import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:litenews/res/colors.dart';
import 'package:litenews/utils/my_dialog.dart';

import '../../db/hello_box.dart';
import '../../db/hello_item_dao.dart';
import '../../db/objectbox.dart';
import '../../objectbox.g.dart';
import '../../utils/logger.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

class HelloLocalPage extends StatefulWidget {
  HelloLocalArguments arguments;

  HelloLocalPage({super.key, required this.arguments});

  @override
  State<StatefulWidget> createState() {
    return HelloLocalState();
  }
}

class HelloLocalState extends State<HelloLocalPage> {
  late InAppWebViewController webViewController;
  late String htmlData;
  late HelloBox helloBox;

  @override
  void initState() {
    super.initState();
    htmlData = '';

    getHtml();
  }

  void getHtml() async {
    helloBox = HelloBox();
    Box<HelloItemDao> box = await ObjectBox().createBox<HelloItemDao>();
    helloBox.initBox(box);
    HelloItemDao hello = (await helloBox.readNote(widget.arguments.mId))!;

    dom.Document document = parse(hello.local_content);

    setState(() {
      htmlData = document
          .getElementsByTagName('main')
          .first
          .getElementsByClassName('relative')
          .first
          .children[1]
          .innerHtml;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.arguments.title),
      ),
      body: getHtmlWidget(),
    );
  }

  Widget getHtmlWidget() {
    return SingleChildScrollView(
      child: HtmlWidget(
        htmlData,
        customStylesBuilder: (element) {
          if (element.classes.contains('text-sm')) {
            return {'font-size': '15px'};
          }
          if (element.classes.contains('grid')) {
            return {'display': 'flex'};
          }
        },
        customWidgetBuilder: (element) {
          if (element.classes.contains('grid')) {
            return Expanded(child: Text(element.text));
          }
        },
      ),
    );
  }
}

class HelloLocalArguments {
  String title;
  int mId;

  HelloLocalArguments({required this.mId, required this.title});
}
