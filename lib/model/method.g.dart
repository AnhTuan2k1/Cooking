// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Method _$MethodFromJson(Map<String, dynamic> json) => Method(
      json['stepid'] as String,
      json['content'] as String,
      (json['image'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MethodToJson(Method instance) => <String, dynamic>{
      'stepid': instance.stepid,
      'content': instance.content,
      'image': instance.image,
    };
