import 'package:json_annotation/json_annotation.dart';

part 'groupInfoModel.g.dart';

@JsonSerializable()
class GroupInfoModel {
  final bool? status;
  final String? message;
  final GroupData? data;

  GroupInfoModel({
    this.status,
    this.message,
    this.data,
  });

  /// Factory method to create an instance from JSON
  factory GroupInfoModel.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoModelFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$GroupInfoModelToJson(this);
}

@JsonSerializable()
class GroupData {
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

  GroupData({
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
  factory GroupData.fromJson(Map<String, dynamic> json) =>
      _$GroupDataFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$GroupDataToJson(this);
}
