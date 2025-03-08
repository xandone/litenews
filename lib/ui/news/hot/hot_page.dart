import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:litenews/res/colors.dart';
import 'package:litenews/ui/news/hot/hot_list_page.dart';

import 'controller/hot_controller.dart';

/// @author: xiao
/// created on: 2025/3/7 16:31
/// description:

const titleTabs = [
  '头条',
  '华尔街',
  '澎湃',
  '财联社',
  '雪球',
  'Hacker News',
  'Product Hunt'
];

class HotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotState();
  }
}

class _HotState extends State<HotPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: titleTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          labelColor: MyColors.b1_color,
          unselectedLabelColor: MyColors.b3_color,
          tabs: titleTabs.map((it) => Tab(text: it)).toList(),
        ),
        Expanded(
            child: TabBarView(
                controller: _tabController,
                children: titleTabs.map((it) => HotListPage()).toList()))
      ],
    );
  }
}
