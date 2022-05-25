

import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User{
  String id;
  String? imageUrl;
  String? name;
  List<String>? following;
  List<String>? savefood;


  User(this.id, this.imageUrl, this.name, this.following, this.savefood);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}