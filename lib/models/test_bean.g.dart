// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestBean _$TestBeanFromJson(Map<String, dynamic> json) => TestBean(
      (json['a'] as num?)?.toInt(),
      (json['b'] as num?)?.toInt(),
      json['c'] as String?,
    );

Map<String, dynamic> _$TestBeanToJson(TestBean instance) => <String, dynamic>{
      'a': instance.a,
      'b': instance.b,
      'c': instance.c,
    };
