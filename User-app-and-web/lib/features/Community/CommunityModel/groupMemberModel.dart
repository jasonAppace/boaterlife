import 'package:json_annotation/json_annotation.dart';

part 'groupMemberModel.g.dart';

@JsonSerializable()
class GroupMemberModel {
  final bool? status;
  final String? message;
  final List<MemberData>? data;

  GroupMemberModel({
    this.status,
    this.message,
    this.data,
  });

  /// Factory method to create an instance from JSON
  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);
}

@JsonSerializable()
class MemberData {
  final int? id;
  @JsonKey(name: 'f_name')
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? image;
  @JsonKey(name: 'cover_image')
  final String? coverImage;
  final String? description;
  final String? gender;
  final String? dob;
  final String? interest;
  @JsonKey(name: 'role_id')
  final int? roleId;
  @JsonKey(name: 'is_admin')
  final int? isAdmin;
  final int? status;
  final String? age;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  final int? encrypted;
  @JsonKey(name: 'email_verification_otp')
  final String? emailVerificationOtp;
  @JsonKey(name: 'email_verification_expires_at')
  final String? emailVerificationExpiresAt;
  final Pivot? pivot;

  MemberData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.image,
    this.coverImage,
    this.description,
    this.gender,
    this.dob,
    this.interest,
    this.roleId,
    this.isAdmin,
    this.status,
    this.age,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.encrypted,
    this.emailVerificationOtp,
    this.emailVerificationExpiresAt,
    this.pivot,
  });

  /// Factory method to create an instance from JSON
  factory MemberData.fromJson(Map<String, dynamic> json) =>
      _$MemberDataFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$MemberDataToJson(this);
}

@JsonSerializable()
class Pivot {
  @JsonKey(name: 'group_id')
  final int? groupId;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'is_admin')
  final int? isAdmin;
  final int? blocked;
  final int? exit;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Pivot({
    this.groupId,
    this.userId,
    this.isAdmin,
    this.blocked,
    this.exit,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory method to create an instance from JSON
  factory Pivot.fromJson(Map<String, dynamic> json) => _$PivotFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$PivotToJson(this);
}
