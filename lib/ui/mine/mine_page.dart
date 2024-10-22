import 'package:flutter/material.dart';
import 'package:litenews/res/colors.dart';
import 'package:litenews/ui/collect/collect_page.dart';

import '../collect/deal_type.dart';

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
      appBar: AppBar(
        title: Text('我的'),
      ),
      body: Column(
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
              title: const Text('备份'),
              leading: const Icon(Icons.archive),
              onTap: () {},
            ),
          )
        ],
      ),
    );
  }
}
