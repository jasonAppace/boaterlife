// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupChatListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupChatListModel _$GroupChatListModelFromJson(Map<String, dynamic> json) =>
    GroupChatListModel(
      messages: json['messages'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : GroupChat.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$GroupChatListModelToJson(GroupChatListModel instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'data': instance.data,
      'status': instance.status,
    };

GroupChat _$GroupChatFromJson(Map<String, dynamic> json) => GroupChat(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      interestId: (json['interest_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      active: (json['active'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      messageUnseen: (json['messageUnseen'] as num?)?.toInt(),
      users: json['users'] as List<dynamic>?,
    );

Map<String, dynamic> _$GroupChatToJson(GroupChat instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'interest_id': instance.interestId,
      'user_id': instance.userId,
      'active': instance.active,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'messageUnseen': instance.messageUnseen,
      'users': instance.users,
    };
