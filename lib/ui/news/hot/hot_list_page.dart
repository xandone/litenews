import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'controller/hot_controller.dart';

/// @author: xiao
/// created on: 2025/3/7 17:03
/// description:
class HotListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotListState();
  }
}

class _HotListState extends State<HotListPage> {
  HotController controller = Get.put(HotController());

  @override
  void initState() {
    super.initState();
    controller.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
        itemCount: controller.datas.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 6, left: 10, right: 10),
            child: Material(
              // color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () async {
                  await Future.delayed(const Duration(microseconds: 200));
                },
                child: Ink(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${index + 1}.${controller.datas[index].title}')
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
