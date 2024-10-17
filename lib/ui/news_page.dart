import 'package:flutter/material.dart';
import 'package:litenews/ui/hellogithub/main_hellogithub.dart';

import '52im/im_list_page.dart';

class NewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewsPageState();
  }
}

class NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('首页'),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: const [
                Tab(
                  text: 'Hello',
                ),
                Tab(
                  text: '52IM',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[ImListPage(), ImListPage()]),
            )
          ],
        ),
      ),
    );
  }
}
