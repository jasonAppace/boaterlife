// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individualChatMessagesModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndividualChatMessagesModel _$IndividualChatMessagesModelFromJson(
        Map<String, dynamic> json) =>
    IndividualChatMessagesModel(
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => MessageIndi.fromJson(e as Map<String, dynamic>))
          .toList(),
      blockedBy: (json['blocked_by'] as List<dynamic>?)
          ?.map((e) => BlockedBy.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$IndividualChatMessagesModelToJson(
        IndividualChatMessagesModel instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'blocked_by': instance.blockedBy,
      'status': instance.status,
    };

MessageIndi _$MessageIndiFromJson(Map<String, dynamic> json) => MessageIndi(
      id: (json['id'] as num?)?.toInt(),
      fromId: (json['from_id'] as num?)?.toInt(),
      toId: (json['to_id'] as num?)?.toInt(),
      groupId: (json['group_id'] as num?)?.toInt(),
      referenceGroupId: (json['reference_group_id'] as num?)?.toInt(),
      replyTo: (json['reply_to'] as num?)?.toInt(),
      body: json['body'] as String?,
      attachment: json['attachment'] as String?,
      seen: (json['seen'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      reply: json['reply'] == null
          ? null
          : MessageIndi.fromJson(json['reply'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageIndiToJson(MessageIndi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from_id': instance.fromId,
      'to_id': instance.toId,
      'group_id': instance.groupId,
      'reference_group_id': instance.referenceGroupId,
      'reply_to': instance.replyTo,
      'body': instance.body,
      'attachment': instance.attachment,
      'seen': instance.seen,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt,
      'user': instance.user,
      'reply': instance.reply,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      name: json['f_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      image: json['image'] as String?,
      coverImage: json['cover_image'] as String?,
      description: json['description'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      interest: json['interest'] as String?,
      roleId: (json['role_id'] as num?)?.toInt(),
      isAdmin: (json['is_admin'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      age: json['age'] as String?,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      encrypted: (json['encrypted'] as num?)?.toInt(),
      emailVerificationOtp: json['email_verification_otp'] as String?,
      emailVerificationExpiresAt: json['email_verification_expires_at'] == null
          ? null
          : DateTime.parse(json['email_verification_expires_at'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'f_name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'image': instance.image,
      'cover_image': instance.coverImage,
      'description': instance.description,
      'gender': instance.gender,
      'dob': instance.dob,
      'interest': instance.interest,
      'role_id': instance.roleId,
      'is_admin': instance.isAdmin,
      'status': instance.status,
      'age': instance.age,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'encrypted': instance.encrypted,
      'email_verification_otp': instance.emailVerificationOtp,
      'email_verification_expires_at':
          instance.emailVerificationExpiresAt?.toIso8601String(),
    };

BlockedBy _$BlockedByFromJson(Map<String, dynamic> json) => BlockedBy(
      blockedBy: (json['blocked_by'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BlockedByToJson(BlockedBy instance) => <String, dynamic>{
      'blocked_by': instance.blockedBy,
    };
