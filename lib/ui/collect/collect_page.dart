import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:litenews/models/convert_utils.dart';

import '../../db/hello_item_dao.dart';
import '../../db/objectbox.dart';
import '../../http/api.dart';
import '../../models/hellogithub/hello_item_bean.dart';
import '../../res/colors.dart';
import '../../utils/logger.dart';
import '../hellogithub/hello_details.dart';

class CollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ColectState();
  }
}

class ColectState extends State<CollectPage> {
  List<HelloItemBean> datas = [];
  late ObjectBox objectbox;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    objectbox = await ObjectBox.create();
    getList();
  }

  void getList() async {
    Stream<List<HelloItemDao>> dao = objectbox.getNotes();
    setState(() {
      datas.clear();
      dao.first.then((list) {
        for (var it in list) {
          HelloItemBean bean=ConvertUtils.getHelloItemBean(it);
          datas.add(bean);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('收藏'),
      ),
      body: EasyRefresh(
        onRefresh: () {
          getList();
        },
        child: ListView.builder(
            itemCount: datas.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Card(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            width: 50,
                            height: 50,
                            imageUrl: datas[index].author_avatar,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            httpHeaders: {
                              'referer': Api.HELLOGITHUB_API,
                            },
                          ),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          datas[index].title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: MyColors.b1_color),
                                        )),
                                        Visibility(
                                            visible:
                                                datas[index].comment_total > 0,
                                            child: Container(
                                              height: 16,
                                              constraints:
                                                  BoxConstraints(minWidth: 16),
                                              // padding: EdgeInsets.all(2),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                '${datas[index].comment_total}',
                                                style: TextStyle(
                                                    color: MyColors.white,
                                                    fontSize: 12),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: MyColors.bl3_color,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4))),
                                            ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          datas[index].summary,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: MyColors.b2_color),
                                        )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          datas[index].primary_lang,
                                          style: TextStyle(
                                              color: MyColors.b2_color,
                                              fontSize: 12),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            datas[index].updated_at,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: MyColors.b2_color),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          )
                        ],
                      )),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HelloDetailsPage(
                      arguments:
                          HelloDetailsArguments(itemId: datas[index].item_id),
                    );
                  }));
                },
                onLongPress: () {},
              );
            }),
      ),
    );
  }
}
