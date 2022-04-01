

import 'package:json_annotation/json_annotation.dart';
part 'method.g.dart';

@JsonSerializable()
class Method{
  String stepid;
  String content;

  @JsonKey(defaultValue: null)
  List<String>? image;


  Method(this.stepid, this.content, this.image);

  factory Method.fromJson(Map<String, dynamic> json) => _$MethodFromJson(json);
  Map<String, dynamic> toJson() => _$MethodToJson(this);
}