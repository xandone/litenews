import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:litenews/db/hello_box.dart';
import 'package:litenews/db/hello_item_dao.dart';
import 'package:litenews/models/convert_utils.dart';
import 'package:objectbox/objectbox.dart';

import '../../db/objectbox.dart';
import '../../http/api.dart';
import '../../http/http_dio.dart';
import '../../models/hellogithub/hello_item_bean.dart';
import '../../objectbox.g.dart';
import '../../res/colors.dart';
import '../../utils/logger.dart';
import '../../utils/my_dialog.dart';
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
  List<HelloItemBean> datas = [];

  late HelloBox helloBox;
  late EasyRefreshController _refreshController;
  late final slidablecontroller = SlidableController(this);

  @override
  void initState() {
    super.initState();

    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    init();

    getList(false);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    slidablecontroller.dispose();
  }

  void init() async {
    helloBox = HelloBox();
    Box<HelloItemDao> box = await ObjectBox().createBox<HelloItemDao>();
    helloBox.initBox(box);
  }

  void getList(bool isMore) async {
    int page = isMore ? datas.length ~/ 10 : 0;
    page = page + 1;

    Map<String, dynamic> params = Map();
    params['page'] = page;
    params['sort_by'] = 'featured';
    params['rank_by'] = 'newest';
    params['tid'] = 'all';

    var result = await MyHttp.instance
        .get('v1/', baseUrl: Api.HELLOGITHUB_API, queryParameters: params);

    setState(() {
      if (!isMore) {
        _refreshController.finishRefresh();
        _refreshController.resetFooter();
        datas.clear();
      }
      for (var item in result['data']) {
        datas.add(HelloItemBean.fromJson(item));
      }

      _refreshController.finishLoad(result['has_more']
          ? IndicatorResult.success
          : IndicatorResult.noMore);
    });
  }

  void collectItem(int index) async {
    save2Db(datas[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh(
        controller: _refreshController,
        onRefresh: () {
          getList(false);
        },
        onLoad: () => getList(true),
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
                            download(datas[index]);
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    datas[index].comment_total >
                                                        0,
                                                child: Container(
                                                  height: 16,
                                                  constraints: BoxConstraints(
                                                      minWidth: 16),
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
                                                              Radius.circular(
                                                                  4))),
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
                                              padding:
                                                  EdgeInsets.only(left: 10),
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
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HelloDetailsPage(
                      arguments:
                          HelloDetailsArguments(itemId: datas[index].item_id),
                    );
                  }));
                },
                onLongPress: () {
                  _showDialog(datas[index]);
                },
              );
            }),
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
    Dio dio = Dio();
    Response response =
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
