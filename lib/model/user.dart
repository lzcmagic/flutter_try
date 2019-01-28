import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User{
  String name;
  String emial;

  User(this.name, this.emial);

  factory User.fromJson(Map<String,dynamic> json)=> _$UserFromJson(json);

  Map<String,dynamic> toJson() => _$UserToJson(this);
}