import 'package:json_annotation/json_annotation.dart';

part 'searchUserModel.g.dart';

@JsonSerializable()
class SearchUserModel {
  final String? message;
  final List<SearchUser>? data;
  final bool? status;

  SearchUserModel({
    this.message,
    this.data,
    this.status,
  });

  /// Factory method to create an instance from JSON
  factory SearchUserModel.fromJson(Map<String, dynamic> json) =>
      _$SearchUserModelFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$SearchUserModelToJson(this);
}

@JsonSerializable()
class SearchUser {
  final int? id;
  @JsonKey(name: 'f_name')
  final String? name;
  final String? email;
  final String? image;

  SearchUser({
    this.id,
    this.name,
    this.email,
    this.image,
  });

  /// Factory method to create an instance from JSON
  factory SearchUser.fromJson(Map<String, dynamic> json) =>
      _$SearchUserFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$SearchUserToJson(this);
}
