import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litenews/db/objectbox.dart';
import 'package:litenews/res/colors.dart';
import 'package:litenews/ui/mine/mine_page.dart';

import 'codes_page.dart';
import 'news/news_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  RxInt index = 0.obs;

  void switchIndex(int index) {
    this.index.value = index;
  }

  @override
  void dispose() {
    super.dispose();
    ObjectBox().close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Center(
            child: IndexedStack(
              index: index.value,
              children: [CodesPage(), NewsPage(), MinePage()],
            ),
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            selectedItemColor: MyColors.b1_color,
            unselectedItemColor: MyColors.b3_color,
            currentIndex: index.value,
            onTap: (index) => {switchIndex(index)},
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.code), label: '编程'),
              BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: '新闻'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_box), label: '我的')
            ],
          )),
    );
  }
}
