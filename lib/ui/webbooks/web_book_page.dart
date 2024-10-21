import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:litenews/res/colors.dart';
import 'package:litenews/ui/webbooks/web_books_details.dart';

import '../../http/api.dart';
import '../../models/webbooks/web_book_bean.dart';

final books = [
  WebBookBean(
      book_name: 'flutter实战',
      item_id: Api.FLUTTER_COMBAT,
      icon: 'assets/images/flu_combat_logo.png',
      isSvg: false),
  WebBookBean(
      book_name: 'hello算法',
      item_id: Api.HELLO_ALGO,
      icon: 'assets/images/hello_algo.svg',
      isSvg: true),
  WebBookBean(
      book_name: '千古前端',
      item_id: Api.QIANGU_YIHAO,
      icon: 'assets/images/qiangu.png',
      isSvg: false),
  WebBookBean(
      book_name: '廖雪峰python',
      item_id: Api.LXF_PYTHON,
      icon: 'assets/images/lxf_python.svg',
      isSvg: true),
];

class WebBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WebBookState();
  }
}

class WebBookState extends State<WebBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                child: Column(
                  children: [
                    Expanded(child: getIcon(books[index])),
                    Text(
                      books[index].book_name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WebBooksDetails(
                      arguments:
                          WebBooksArguments(itemId: books[index].item_id),
                    );
                  }));
                });
          },
        ),
      ),
    );
  }

  Widget getIcon(WebBookBean bookBean) {
    if (bookBean.isSvg) {
      return SvgPicture.asset(bookBean.icon);
    } else {
      return Image(
        image: AssetImage(bookBean.icon),
      );
    }
  }
}
