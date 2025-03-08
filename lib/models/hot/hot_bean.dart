import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class HotBean {
  HotBean({
    required this.id,
    required this.title,
    required this.url,
  });

  factory HotBean.fromJson(Map<String, dynamic> json) => HotBean(
        id: asT<dynamic>(json['id'])!,
        title: asT<String>(json['title'])!,
        url: asT<String>(json['url'])!,
      );

  dynamic id;
  String title;
  String url;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'url': url,
      };
}
