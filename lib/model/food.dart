
import 'package:json_annotation/json_annotation.dart';
import 'comment.dart';
import 'method.dart';

part 'food.g.dart';

@JsonSerializable(explicitToJson: true)
class Food{
  String name;
  String description;
  String by;
  String dateCreate;
  List<String> ingredients;
  List<Method> method;

  @JsonKey(defaultValue: null)
  String? identify;

  @JsonKey(defaultValue: null)
  String? origin;

  @JsonKey(defaultValue: null)
  String? image;

  @JsonKey(defaultValue: 1)
  int serves;

  @JsonKey(defaultValue: 45)
  int? cookTime;

  @JsonKey(defaultValue: null)
  List<String>? likes;

  @JsonKey(defaultValue: null)
  List<Comment>? comments;

  Food(
      this.name,
      this.description,
      this.by,
      this.serves,
      this.dateCreate,
      this.ingredients,
      this.method,
      this.identify,
      this.origin,
      this.image,
      this.cookTime,
      this.likes,
      this.comments);

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}