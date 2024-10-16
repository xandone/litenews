import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class HelloItemBean {
  HelloItemBean({
    required this.author,
    required this.author_avatar,
    required this.comment_total,
    required this.item_id,
    required this.name,
    required this.primary_lang,
    required this.summary,
    required this.summary_en,
    required this.title,
    required this.title_en,
    required this.updated_at,
  });

  factory HelloItemBean.fromJson(Map<String, dynamic> json) => HelloItemBean(
        author: asT<String>(json['author'])!,
        author_avatar: asT<String>(json['author_avatar'])!,
        comment_total: asT<int>(json['comment_total'])!,
        item_id: asT<String>(json['item_id'])!,
        name: asT<String>(json['name'])!,
        primary_lang: asT<String>(json['primary_lang'])!,
        summary: asT<String>(json['summary'])!,
        summary_en: asT<String>(json['summary_en'])!,
        title: asT<String>(json['title'])!,
        title_en: asT<String>(json['title_en'])!,
        updated_at: asT<String>(json['updated_at'])!,
      );

  String author;
  String author_avatar;
  int comment_total;
  String item_id;
  String name;

  String primary_lang;
  String summary;
  String summary_en;
  String title;
  String title_en;

  String updated_at;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'author': author,
        'author_avatar': author_avatar,
        'comment_total': comment_total,
        'item_id': item_id,
        'name': name,
        'primary_lang': primary_lang,
        'summary': summary,
        'summary_en': summary_en,
        'title': title,
        'title_en': title_en,
        'updated_at': updated_at,
      };
}
