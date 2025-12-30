import 'package:json_annotation/json_annotation.dart';

part 'myGroupsModel.g.dart';

@JsonSerializable()
class MyGroupsModel {
  final bool? status;
  final String? message;
  final List<MyGroup>? data;

  MyGroupsModel({
    this.status,
    this.message,
    this.data,
  });

  /// Factory method to create an instance from JSON
  factory MyGroupsModel.fromJson(Map<String, dynamic> json) =>
      _$MyGroupsModelFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$MyGroupsModelToJson(this);
}

@JsonSerializable()
class MyGroup {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  @JsonKey(name: 'interest_id')
  final int? interestId;
  @JsonKey(name: 'user_id')
  final int? userId;
  final int? active;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  MyGroup({
    this.id,
    this.name,
    this.description,
    this.image,
    this.interestId,
    this.userId,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory method to create an instance from JSON
  factory MyGroup.fromJson(Map<String, dynamic> json) =>
      _$MyGroupFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$MyGroupToJson(this);
}
