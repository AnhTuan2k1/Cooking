
import 'package:cooking/model/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment{
  User user;
  String message;
  String identify;

  int? timeCreated;


  Comment(this.user, this.message, this.identify, this.timeCreated);

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}