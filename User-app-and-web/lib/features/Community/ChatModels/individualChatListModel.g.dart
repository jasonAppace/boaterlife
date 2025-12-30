// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individualChatListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndividualChatListModel _$IndividualChatListModelFromJson(
        Map<String, dynamic> json) =>
    IndividualChatListModel(
      messages: json['messages'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => IndividualChat.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$IndividualChatListModelToJson(
        IndividualChatListModel instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'data': instance.data,
      'status': instance.status,
    };

IndividualChat _$IndividualChatFromJson(Map<String, dynamic> json) =>
    IndividualChat(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      image: json['image'] as String?,
      coverImage: json['coverImage'] as String?,
      description: json['description'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      interest: json['interest'] as String?,
      roleId: (json['roleId'] as num?)?.toInt(),
      isAdmin: (json['isAdmin'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      age: json['age'] as String?,
      emailVerifiedAt: json['emailVerifiedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      encrypted: (json['encrypted'] as num?)?.toInt(),
      emailVerificationOtp: json['emailVerificationOtp'] as String?,
      emailVerificationExpiresAt: json['emailVerificationExpiresAt'] as String?,
      latest: json['latest'] == null
          ? null
          : LatestMessage.fromJson(json['latest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IndividualChatToJson(IndividualChat instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'image': instance.image,
      'coverImage': instance.coverImage,
      'description': instance.description,
      'gender': instance.gender,
      'dob': instance.dob,
      'interest': instance.interest,
      'roleId': instance.roleId,
      'isAdmin': instance.isAdmin,
      'status': instance.status,
      'age': instance.age,
      'emailVerifiedAt': instance.emailVerifiedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'encrypted': instance.encrypted,
      'emailVerificationOtp': instance.emailVerificationOtp,
      'emailVerificationExpiresAt': instance.emailVerificationExpiresAt,
      'latest': instance.latest,
    };

LatestMessage _$LatestMessageFromJson(Map<String, dynamic> json) =>
    LatestMessage(
      id: (json['id'] as num?)?.toInt(),
      fromId: (json['fromId'] as num?)?.toInt(),
      toId: (json['toId'] as num?)?.toInt(),
      groupId: json['groupId'] as String?,
      referenceGroupId: json['referenceGroupId'] as String?,
      replyTo: (json['replyTo'] as num?)?.toInt(),
      body: json['body'] as String?,
      attachment: json['attachment'] as String?,
      seen: (json['seen'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$LatestMessageToJson(LatestMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromId': instance.fromId,
      'toId': instance.toId,
      'groupId': instance.groupId,
      'referenceGroupId': instance.referenceGroupId,
      'replyTo': instance.replyTo,
      'body': instance.body,
      'attachment': instance.attachment,
      'seen': instance.seen,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
