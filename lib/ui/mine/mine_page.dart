import 'package:flutter/material.dart';
import 'package:litenews/res/colors.dart';
import 'package:litenews/ui/collect/collect_page.dart';

import '../collect/deal_type.dart';
import 'about_data_page.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MineState();
  }
}

class MineState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Card(
            color: MyColors.white,
            child: ListTile(
              title: const Text('收藏'),
              leading: const Icon(Icons.collections_bookmark),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const CollectPage(dealType: DealType.collectionType);
                }));
              },
            ),
          ),
          Card(
            color: MyColors.white,
            child: ListTile(
              title: const Text('下载'),
              leading: const Icon(Icons.download),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const CollectPage(dealType: DealType.downloadType);
                }));
              },
            ),
          ),
          Card(
            color: MyColors.white,
            child: ListTile(
              title: const Text('数据来源'),
              leading: const Icon(Icons.data_exploration),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AboutDataPage();
                }));
              },
            ),
          ),
          Card(
            color: MyColors.white,
            child: ListTile(
              title: const Text('备份'),
              leading: const Icon(Icons.archive),
              onTap: () {},
            ),
          ),
        ],
      )),
    );
  }
}
