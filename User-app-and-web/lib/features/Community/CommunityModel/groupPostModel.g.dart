// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupPostModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupPostModel _$GroupPostModelFromJson(Map<String, dynamic> json) =>
    GroupPostModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PostData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupPostModelToJson(GroupPostModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

PostData _$PostDataFromJson(Map<String, dynamic> json) => PostData(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      content:
          (json['content'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userId: (json['user_id'] as num?)?.toInt(),
      groupId: (json['group_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      users: json['users'] == null
          ? null
          : UserData.fromJson(json['users'] as Map<String, dynamic>),
      groups: json['groups'] == null
          ? null
          : GroupData.fromJson(json['groups'] as Map<String, dynamic>),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentData.fromJson(e as Map<String, dynamic>))
          .toList(),
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => LikeData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostDataToJson(PostData instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'user_id': instance.userId,
      'group_id': instance.groupId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'users': instance.users,
      'groups': instance.groups,
      'comments': instance.comments,
      'likes': instance.likes,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['f_name'] as String?,
      lastName: json['l_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      isPhoneVerified: (json['is_phone_verified'] as num?)?.toInt(),
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      emailVerificationToken: json['email_verification_token'] as String?,
      cmFirebaseToken: json['cm_firebase_token'] as String?,
      temporaryToken: json['temporary_token'] as String?,
      loginHitCount: (json['login_hit_count'] as num?)?.toInt(),
      isTempBlocked: (json['is_temp_blocked'] as num?)?.toInt(),
      tempBlockTime: json['temp_block_time'] as String?,
      loginMedium: json['login_medium'] as String?,
      imageFullPath: json['image_fullpath'] as String?,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'f_name': instance.firstName,
      'l_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'image': instance.image,
      'is_phone_verified': instance.isPhoneVerified,
      'email_verified_at': instance.emailVerifiedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'email_verification_token': instance.emailVerificationToken,
      'cm_firebase_token': instance.cmFirebaseToken,
      'temporary_token': instance.temporaryToken,
      'login_hit_count': instance.loginHitCount,
      'is_temp_blocked': instance.isTempBlocked,
      'temp_block_time': instance.tempBlockTime,
      'login_medium': instance.loginMedium,
      'image_fullpath': instance.imageFullPath,
    };

GroupData _$GroupDataFromJson(Map<String, dynamic> json) => GroupData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      active: (json['active'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$GroupDataToJson(GroupData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'user_id': instance.userId,
      'active': instance.active,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CommentData _$CommentDataFromJson(Map<String, dynamic> json) => CommentData(
      id: (json['id'] as num?)?.toInt(),
      comment: json['comment'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      postId: (json['post_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      users: json['users'] == null
          ? null
          : UserData.fromJson(json['users'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentDataToJson(CommentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'user_id': instance.userId,
      'post_id': instance.postId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'users': instance.users,
    };

LikeData _$LikeDataFromJson(Map<String, dynamic> json) => LikeData(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      likeableType: json['likeable_type'] as String?,
      likeableId: (json['likeable_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      users: json['users'] == null
          ? null
          : UserData.fromJson(json['users'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LikeDataToJson(LikeData instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'likeable_type': instance.likeableType,
      'likeable_id': instance.likeableId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'users': instance.users,
    };
