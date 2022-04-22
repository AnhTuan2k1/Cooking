// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      User.fromJson(json['user'] as Map<String, dynamic>),
      json['message'] as String,
      json['identify'] as String,
      json['timeCreated'] as int?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'user': instance.user.toJson(),
      'message': instance.message,
      'identify': instance.identify,
      'timeCreated': instance.timeCreated,
    };
