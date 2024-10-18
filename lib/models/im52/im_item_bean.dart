import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class ImItemBean {
  ImItemBean({
    required this.comment_total,
    required this.item_id,
    required this.primary_lang,
    required this.title,
    required this.updated_at,
  });

  factory ImItemBean.fromJson(Map<String, dynamic> json) => ImItemBean(
    comment_total: asT<int>(json['comment_total'])!,
    item_id: asT<String>(json['item_id'])!,
    primary_lang: asT<String>(json['primary_lang'])!,
    title: asT<String>(json['title'])!,
    updated_at: asT<String>(json['updated_at'])!,
  );

  int comment_total;
  String item_id;
  String primary_lang;
  String title;
  String updated_at;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'comment_total': comment_total,
    'item_id': item_id,
    'primary_lang': primary_lang,
    'title': title,
    'updated_at': updated_at,
  };
}
