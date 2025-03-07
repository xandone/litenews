import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as ddio;
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:litenews/db/hello_box.dart';
import 'package:litenews/db/hello_item_dao.dart';
import 'package:litenews/models/convert_utils.dart';
import 'package:objectbox/objectbox.dart';

import '../../db/objectbox.dart';
import '../../http/api.dart';
import '../../models/hellogithub/hello_item_bean.dart';
import '../../objectbox.g.dart';
import '../../res/colors.dart';
import '../../utils/my_dialog.dart';
import 'controller/hellogithub_controller.dart';
import 'hello_details.dart';

class MainHellogithubPage extends StatefulWidget {
  const MainHellogithubPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainHellogithubState();
  }
}

class MainHellogithubState extends State<MainHellogithubPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  HellogithubController controller = Get.put(HellogithubController());

  late HelloBox helloBox;
  late final slidablecontroller = SlidableController(this);

  @override
  void initState() {
    super.initState();

    init();

    controller.getList(false);
  }

  @override
  void dispose() {
    super.dispose();
    controller.refreshController.dispose();
    slidablecontroller.dispose();
  }

  void init() async {
    helloBox = HelloBox();
    Box<HelloItemDao> box = await ObjectBox().createBox<HelloItemDao>();
    helloBox.initBox(box);
  }

  void collectItem(int index) async {
    save2Db(controller.datas[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh(
        controller: controller.refreshController,
        onRefresh: () {
          controller.getList(false);
        },
        onLoad: () => controller.getList(true),
        child: Obx(() => ListView.builder(
            itemCount: controller.datas.length,
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
                            collectItem(index);
                            slidablecontroller.close();
                          },
                          backgroundColor: MyColors.collection_color,
                          foregroundColor: Colors.white,
                          icon: Icons.collections_bookmark,
                          label: '收藏',
                        ),
                        SlidableAction(
                          flex: 1,
                          onPressed: (_) {
                            download(controller.datas[index]);
                            slidablecontroller.close();
                          },
                          backgroundColor: MyColors.download_color,
                          foregroundColor: Colors.white,
                          icon: Icons.download,
                          label: '下载',
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: Container(
                      child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                width: 50,
                                height: 50,
                                imageUrl: controller.datas[index].author_avatar,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                httpHeaders: const {
                                  'referer': Api.HELLOGITHUB_API,
                                },
                              ),
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              controller.datas[index].title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: MyColors.b1_color),
                                            )),
                                            Visibility(
                                                visible: controller.datas[index]
                                                        .comment_total >
                                                    0,
                                                child: Container(
                                                  height: 16,
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 16),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: MyColors
                                                              .bl3_color,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4))),
                                                  // padding: EdgeInsets.all(2),
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    '${controller.datas[index].comment_total}',
                                                    style: const TextStyle(
                                                        color: MyColors.white,
                                                        fontSize: 12),
                                                  ),
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              controller.datas[index].summary,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: MyColors.b2_color),
                                            )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              controller
                                                  .datas[index].primary_lang,
                                              style: const TextStyle(
                                                  color: MyColors.b2_color,
                                                  fontSize: 12),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                controller
                                                    .datas[index].updated_at,
                                                style: const TextStyle(
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
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HelloDetailsPage(
                      arguments: HelloDetailsArguments(
                          itemId: controller.datas[index].item_id),
                    );
                  }));
                },
                onLongPress: () {
                  // _showDialog(datas[index]);
                },
              );
            })),
      ),
    );
  }

  void showAttachDialog(BuildContext ctx, HelloItemBean bean) {
    MyDialog.showAttachDialog(context, '收藏');
  }

  @deprecated
  void _showDialog(HelloItemBean bean) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('收藏'),
          content: Text(bean.title),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          contentPadding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 10),
          actions: <Widget>[
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                save2Db(bean);
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
  }

  void save2Db(HelloItemBean bean) async {
    helloBox.addNote(ConvertUtils.getHelloItemDaoByHello(bean: bean));
  }

  void download(HelloItemBean bean) async {
    MyDialog.showLoading(msg: '下载中');
    ddio.Dio dio = ddio.Dio();
    ddio.Response response =
        await dio.get('${Api.HELLOGITHUB_PAGE}/repository/${bean.item_id}');
    String content = response.data.toString();
    // Log.d(content);
    helloBox.addNote(
        ConvertUtils.getHelloItemDaoByHello(bean: bean, details: content));
    MyDialog.dismiss();
  }

  @override
  bool get wantKeepAlive => true;
}
