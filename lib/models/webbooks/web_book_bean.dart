import 'dart:async';
import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class WebBookBean {
  WebBookBean({
    required this.book_name,
    required this.item_id,
    required this.icon,
    required this.isSvg,
    this.current_url = '',
  });

  factory WebBookBean.fromJson(Map<String, dynamic> json) => WebBookBean(
        book_name: asT<String>(json['book_name'])!,
        item_id: asT<String>(json['item_id'])!,
        icon: asT<String>(json['icon'])!,
        isSvg: asT<bool>(json['isSvg'])!,
        current_url: asT<String>(json['current_url'])!,
      );

  String book_name;
  String item_id;
  String icon;
  bool isSvg;
  String current_url;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'book_name': book_name,
        'item_id': item_id,
        'icon': icon,
        'isSvg': isSvg,
        'current_url': current_url,
      };
}
