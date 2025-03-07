import 'package:flutter/material.dart';
import 'package:litenews/ui/hellogithub/main_hellogithub.dart';
import 'package:litenews/ui/webbooks/web_book_page.dart';

import '52im/im_list_page.dart';

class CodesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewsPageState();
  }
}

class NewsPageState extends State<CodesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                Tab(
                  text: 'webBooks',
                )
              ],
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: <Widget>[
                const MainHellogithubPage(),
                ImListPage(),
                WebBookPage(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
