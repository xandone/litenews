import 'dart:async';
import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class AboutDataBean {
  AboutDataBean({
    required this.name,
    required this.item_id,
  });

  factory AboutDataBean.fromJson(Map<String, dynamic> json) => AboutDataBean(
    name: asT<String>(json['book_name'])!,
    item_id: asT<String>(json['item_id'])!,
  );

  String name;
  String item_id;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'item_id': item_id,
  };
}
