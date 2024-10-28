import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../http/api.dart';
import '../../models/data/about_data_bean.dart';

final sDatas = [
  AboutDataBean(name: 'HelloGithub', item_id: Api.HELLOGITHUB_PAGE),
  AboutDataBean(name: '52IM', item_id: Api.IM52_PAGE),
  AboutDataBean(name: 'flutter实战', item_id: Api.FLUTTER_COMBAT),
  AboutDataBean(name: 'hello算法', item_id: Api.HELLO_ALGO),
  AboutDataBean(name: '千古前端', item_id: Api.QIANGU_YIHAO),
  AboutDataBean(name: '廖雪峰python', item_id: Api.LXF_PYTHON),
  AboutDataBean(name: 'GSY_Flutter', item_id: Api.GSY_HOME),
  AboutDataBean(name: 'Real-Time Rendering 4th', item_id: Api.REAL_TIME_RENDERING_4TH),
];

class AboutDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('数据来源'),
      ),
      body: ListView.separated(
          itemCount: sDatas.length,
          separatorBuilder: (context, index) {
            return const Divider(
              height: 10,
              thickness: 0.5,
            );
          },
          itemBuilder: (context, index) {
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${sDatas[index].name}：'),
                  Text(sDatas[index].item_id),
                ],
              ),
            );
          }),
    );
  }
}
