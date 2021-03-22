import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(
      {this.points,
      this.age,
      this.gender,
      this.username,
      this.email,
      this.ip,
      this.type,
      this.uid});

  final int points;
  final String age;
  final String uid;
  final String username;
  final String gender;
  final String email;
  final String ip;
  final String type;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}