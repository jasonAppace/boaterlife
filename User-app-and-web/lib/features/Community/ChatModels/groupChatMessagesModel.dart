import 'package:json_annotation/json_annotation.dart';

part 'groupChatMessagesModel.g.dart';

@JsonSerializable()
class GroupChatMessagesModel {
  final List<Message?>? messages;
  final Group? group;
  final int? blocked;
  final bool? status;

  GroupChatMessagesModel({
    this.messages,
    this.group,
    this.blocked,
    this.status,
  });

  /// Factory method to create an instance from JSON
  factory GroupChatMessagesModel.fromJson(Map<String, dynamic> json) =>
      _$GroupChatMessagesModelFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$GroupChatMessagesModelToJson(this);
}

@JsonSerializable()
class Message {
  final int? id;
  @JsonKey(name: 'from_id')
  final int? fromId;
  @JsonKey(name: 'to_id')
  final int? toId;
  @JsonKey(name: 'group_id')
  final int? groupId;
  @JsonKey(name: 'reference_group_id')
  final int? referenceGroupId;
  @JsonKey(name: 'reply_to')
  final int? replyTo;
  final String? body;
  final String? attachment;
  final int? seen;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final User? user;
  final dynamic reply;

  Message({
    this.id,
    this.fromId,
    this.toId,
    this.groupId,
    this.referenceGroupId,
    this.replyTo,
    this.body,
    this.attachment,
    this.seen,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.reply,
  });

  /// Factory method to create an instance from JSON
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class Group {
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

  Group({
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
  factory Group.fromJson(Map<String, dynamic> json) =>
      _$GroupFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable()
class User {
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

  User({
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
  });

  /// Factory method to create an instance from JSON
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
