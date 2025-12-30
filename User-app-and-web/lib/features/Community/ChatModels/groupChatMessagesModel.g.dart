// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupChatMessagesModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupChatMessagesModel _$GroupChatMessagesModelFromJson(
        Map<String, dynamic> json) =>
    GroupChatMessagesModel(
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      group: json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
      blocked: (json['blocked'] as num?)?.toInt(),
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$GroupChatMessagesModelToJson(
        GroupChatMessagesModel instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'group': instance.group,
      'blocked': instance.blocked,
      'status': instance.status,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: (json['id'] as num?)?.toInt(),
      fromId: (json['from_id'] as num?)?.toInt(),
      toId: (json['to_id'] as num?)?.toInt(),
      groupId: (json['group_id'] as num?)?.toInt(),
      referenceGroupId: (json['reference_group_id'] as num?)?.toInt(),
      replyTo: (json['reply_to'] as num?)?.toInt(),
      body: json['body'] as String?,
      attachment: json['attachment'] as String?,
      seen: (json['seen'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      reply: json['reply'],
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'from_id': instance.fromId,
      'to_id': instance.toId,
      'group_id': instance.groupId,
      'reference_group_id': instance.referenceGroupId,
      'reply_to': instance.replyTo,
      'body': instance.body,
      'attachment': instance.attachment,
      'seen': instance.seen,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user': instance.user,
      'reply': instance.reply,
    };

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      interestId: (json['interest_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      active: (json['active'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'interest_id': instance.interestId,
      'user_id': instance.userId,
      'active': instance.active,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
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
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      encrypted: (json['encrypted'] as num?)?.toInt(),
      emailVerificationOtp: json['email_verification_otp'] as String?,
      emailVerificationExpiresAt:
          json['email_verification_expires_at'] as String?,
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
      'email_verified_at': instance.emailVerifiedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'encrypted': instance.encrypted,
      'email_verification_otp': instance.emailVerificationOtp,
      'email_verification_expires_at': instance.emailVerificationExpiresAt,
    };
