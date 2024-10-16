import '../db/hello_item_dao.dart';
import 'hellogithub/hello_item_bean.dart';

class ConvertUtils {
 static HelloItemDao getHelloItemDao(HelloItemBean bean) {
    return HelloItemDao(author: bean.author,
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

 static HelloItemBean getHelloItemBean(HelloItemDao bean) {
   return HelloItemBean(author: bean.author,
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
