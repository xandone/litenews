import 'package:flutter/material.dart';
import 'package:litenews/res/colors.dart';
import 'package:litenews/ui/hellogithub/main_hellogithub.dart';
import 'package:litenews/ui/mine/mine_page.dart';

import '../utils/logger.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  int _index = 0;

  void switchIndex(int index) {
    Log.d('index=$index');
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _index,
          children: [MainHellogithubPage(), MinePage()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: MyColors.main_color,
        currentIndex: _index,
        onTap: (index) => {switchIndex(index)},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: '资讯'),
          BottomNavigationBarItem(icon: Icon(Icons.my_library_add), label: '我的')
        ],
      ),
    );
  }
}
