import 'package:litenews/models/im52/im_item_bean.dart';

import '../db/hello_item_dao.dart';
import 'hellogithub/hello_item_bean.dart';

class ConvertUtils {
  static HelloItemDao getHelloItemDaoByHello(
      {required HelloItemBean bean, String details = ''}) {
    return HelloItemDao(
      type: 1,
      deal_type: details.isEmpty ? 1 : 2,
      author: bean.author,
      author_avatar: bean.author_avatar,
      comment_total: bean.comment_total,
      item_id: bean.item_id,
      name: bean.name,
      primary_lang: bean.primary_lang,
      summary: bean.summary,
      summary_en: bean.summary_en,
      title: bean.title,
      title_en: bean.title_en,
      updated_at: bean.updated_at,
      local_content: details,
    );
  }

  static HelloItemDao getHelloItemDaoByIM(
      {required ImItemBean bean, String details = ''}) {
    return HelloItemDao(
      type: 2,
      deal_type: details.isEmpty ? 1 : 2,
      comment_total: bean.comment_total,
      item_id: bean.item_id,
      primary_lang: bean.primary_lang,
      title: bean.title,
      updated_at: bean.updated_at,
      local_content: details,
    );
  }

  static HelloItemBean getHelloItemBean(HelloItemDao bean) {
    return HelloItemBean(
        author: bean.author,
        author_avatar: bean.author_avatar,
        comment_total: bean.comment_total,
        item_id: bean.item_id,
        name: bean.name,
        primary_lang: bean.primary_lang,
        summary: bean.summary,
        summary_en: bean.summary_en,
        title: bean.title,
        title_en: bean.title_en,
        updated_at: bean.updated_at);
  }
}
