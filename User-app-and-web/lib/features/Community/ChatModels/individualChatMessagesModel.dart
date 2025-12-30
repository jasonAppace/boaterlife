import 'package:json_annotation/json_annotation.dart';

part 'individualChatMessagesModel.g.dart';

@JsonSerializable()
class IndividualChatMessagesModel {
  final List<MessageIndi>? messages;
  @JsonKey(name: 'blocked_by')
  final List<BlockedBy>? blockedBy;
  final bool? status;

  IndividualChatMessagesModel({
    this.messages,
    this.blockedBy,
    this.status,
  });

  factory IndividualChatMessagesModel.fromJson(Map<String, dynamic> json) =>
      _$IndividualChatMessagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$IndividualChatMessagesModelToJson(this);
}

@JsonSerializable()
class MessageIndi {
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
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final User? user;
  final MessageIndi? reply;

  MessageIndi({
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

  factory MessageIndi.fromJson(Map<String, dynamic> json) =>
      _$MessageIndiFromJson(json);

  Map<String, dynamic> toJson() => _$MessageIndiToJson(this);
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
  final DateTime? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  final int? encrypted;
  @JsonKey(name: 'email_verification_otp')
  final String? emailVerificationOtp;
  @JsonKey(name: 'email_verification_expires_at')
  final DateTime? emailVerificationExpiresAt;

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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class BlockedBy {
  @JsonKey(name: 'blocked_by')
  final int? blockedBy;

  BlockedBy({
    this.blockedBy,
  });

  factory BlockedBy.fromJson(Map<String, dynamic> json) =>
      _$BlockedByFromJson(json);

  Map<String, dynamic> toJson() => _$BlockedByToJson(this);
}
