import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:litenews/models/convert_utils.dart';
import 'package:litenews/ui/collect/deal_type.dart';

import '../../db/hello_box.dart';
import '../../db/hello_item_dao.dart';
import '../../db/objectbox.dart';
import '../../http/api.dart';
import '../../objectbox.g.dart';
import '../../res/colors.dart';
import '../../utils/logger.dart';
import '../52im/im_details_page.dart';
import '../hellogithub/hello_details.dart';
import '../hellogithub/hello_local_page.dart';

class CollectPage extends StatefulWidget {
  final DealType dealType;
  final String title;

  const CollectPage({super.key, required this.dealType, this.title = ''});

  @override
  State<StatefulWidget> createState() {
    return ColectState();
  }
}

class ColectState extends State<CollectPage>
    with SingleTickerProviderStateMixin {
  List<HelloItemDao> datas = [];
  late HelloBox helloBox;
  late final slidablecontroller = SlidableController(this);

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    slidablecontroller.dispose();
  }

  void init() async {
    helloBox = HelloBox();
    Box<HelloItemDao> box = await ObjectBox().createBox<HelloItemDao>();
    helloBox.initBox(box);
    getList();
  }

  void getList() async {
    Stream<List<HelloItemDao>> dao = helloBox.getNotes(widget.dealType);
    setState(() {
      datas.clear();
      dao.first.then((list) {
        datas.addAll(list);
        Log.d(datas[0].local_content);
      });
    });
  }

  void deleteItem(int index) async {
    Log.d('itemDao.id=${datas[index].id}');
    await helloBox.removeNote(datas[index].id);
    setState(() {
      datas.removeAt(index);
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
                  child: Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: const ValueKey(0),

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 1,
                          onPressed: (_) {
                            deleteItem(index);
                            slidablecontroller.close();
                          },
                          backgroundColor: MyColors.r5_color,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: '删除',
                        ),
                        // SlidableAction(
                        //   flex: 1,
                        //   onPressed: (_) => controller.close(),
                        //   backgroundColor: const Color(0xFF0392CF),
                        //   foregroundColor: Colors.white,
                        //   icon: Icons.save,
                        //   label: '置顶',
                        // ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: Container(
                      child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: getItem(datas[index])),
                    ),
                  ),
                ),
                onTap: () {
                  var arg;
                  switch (datas[index].type) {
                    case 1:
                      if (datas[index].local_content.isNotEmpty) {
                        arg = HelloLocalPage(
                          arguments: HelloLocalArguments(
                              title: datas[index].title, mId: datas[index].id),
                        );
                      } else {
                        arg = HelloDetailsPage(
                          arguments: HelloDetailsArguments(
                              itemId: datas[index].item_id,
                              isFromDb: datas[index].local_content.isNotEmpty,
                              mId: datas[index].id),
                        );
                      }
                      break;
                    case 2:
                      arg = ImDetailsPage(
                          arguments: ImDetailsArguments(
                              itemId: datas[index].item_id,
                              title: datas[index].title));
                      break;
                  }

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return arg;
                  }));
                },
                onLongPress: () {},
              );
            }),
      ),
    );
  }

  Widget? getItem(HelloItemDao itemDao) {
    switch (itemDao.type) {
      case 1:
        return Row(
          children: [
            CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: itemDao.author_avatar,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
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
                            itemDao.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: MyColors.b1_color),
                          )),
                          Visibility(
                              visible: false,
                              child: Container(
                                height: 16,
                                constraints: BoxConstraints(minWidth: 16),
                                // padding: EdgeInsets.all(2),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  '${itemDao.comment_total}',
                                  style: TextStyle(
                                      color: MyColors.white, fontSize: 12),
                                ),
                                decoration: BoxDecoration(
                                    color: MyColors.bl3_color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            itemDao.summary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, color: MyColors.b2_color),
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            itemDao.primary_lang,
                            style: TextStyle(
                                color: MyColors.b2_color, fontSize: 12),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              itemDao.updated_at,
                              style: TextStyle(
                                  fontSize: 12, color: MyColors.b2_color),
                            ),
                          ),
                          const Expanded(
                              child: Text(
                            textAlign: TextAlign.right,
                            'hello-github',
                            style: TextStyle(
                                fontSize: 12, color: MyColors.main_color),
                          ))
                        ],
                      )
                    ],
                  )),
            )
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  itemDao.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, color: MyColors.b1_color),
                )),
                Visibility(
                    visible: false,
                    child: Container(
                      height: 16,
                      constraints: BoxConstraints(minWidth: 16),
                      // padding: EdgeInsets.all(2),
                      child: Text(
                        textAlign: TextAlign.center,
                        '${itemDao.comment_total}',
                        style: TextStyle(color: MyColors.white, fontSize: 12),
                      ),
                      decoration: BoxDecoration(
                          color: MyColors.bl3_color,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ))
              ],
            ),
            Row(
              children: [
                Visibility(
                    visible: itemDao.primary_lang.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        itemDao.primary_lang,
                        style:
                            TextStyle(color: MyColors.b2_color, fontSize: 12),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    itemDao.updated_at,
                    style: TextStyle(fontSize: 12, color: MyColors.b2_color),
                  ),
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.right,
                    'IM52',
                    style: TextStyle(fontSize: 12, color: MyColors.main_color),
                  ),
                )
              ],
            ),
          ],
        );
      default:
        return null;
    }
  }
}
