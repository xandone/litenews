import 'package:flutter/material.dart';
import 'package:litenews/db/objectbox.dart';
import 'package:litenews/res/colors.dart';
import 'package:litenews/ui/hellogithub/main_hellogithub.dart';
import 'package:litenews/ui/mine/mine_page.dart';

import '../utils/logger.dart';
import 'news_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  int _index = 0;

  void switchIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    ObjectBox().close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _index,
          children: [NewsPage(), MinePage()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: MyColors.b1_color,
        unselectedItemColor: MyColors.b3_color,
        currentIndex: _index,
        onTap: (index) => {switchIndex(index)},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: '内容'),
          BottomNavigationBarItem(icon: Icon(Icons.account_box), label: '我的')
        ],
      ),
    );
  }
}
