import 'package:json_annotation/json_annotation.dart';

part 'test_bean.g.dart';

@JsonSerializable()
class TestBean {
  int? a;
  int? b;
  String? c;

  TestBean(this.a, this.b, this.c);

  // 3、_${类名}FromJson(json) json转对象固定写法 flutter pub run build_runner build --delete-conflicting-outputs
  factory TestBean.fromJson(Map<String, dynamic> json) =>
      _$TestBeanFromJson(json);

  // 4、_${类名}ToJson(json)  对象转json固定写法 }
  Map<String, dynamic> toJson() => _$TestBeanToJson(this);
}
