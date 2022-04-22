// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Food _$FoodFromJson(Map<String, dynamic> json) => Food(
      json['name'] as String,
      json['description'] as String,
      json['by'] as String?,
      json['serves'] as int? ?? 1,
      json['dateCreate'] as String,
      (json['ingredients'] as List<dynamic>).map((e) => e as String).toList(),
      (json['method'] as List<dynamic>)
          .map((e) => Method.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['identify'] as String?,
      json['origin'] as String?,
      json['image'] as String?,
      json['cookTime'] as int? ?? 45,
      (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'dateCreate': instance.dateCreate,
      'ingredients': instance.ingredients,
      'method': instance.method.map((e) => e.toJson()).toList(),
      'by': instance.by,
      'identify': instance.identify,
      'origin': instance.origin,
      'image': instance.image,
      'serves': instance.serves,
      'cookTime': instance.cookTime,
      'likes': instance.likes,
      'comments': instance.comments?.map((e) => e.toJson()).toList(),
    };
