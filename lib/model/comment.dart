
import 'package:json_annotation/json_annotation.dart';
part 'comment.g.dart';

@JsonSerializable()
class Comment{
  String user;
  String message;
  String timeCreated;

  Comment(this.user, this.message, this.timeCreated);

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}