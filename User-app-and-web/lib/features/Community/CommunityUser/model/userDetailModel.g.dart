// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userDetailModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailModel _$UserDetailModelFromJson(Map<String, dynamic> json) =>
    UserDetailModel(
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : UserData.fromJson(json['data'] as Map<String, dynamic>),
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$UserDetailModelToJson(UserDetailModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
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
      blocked: json['blocked'] as bool?,
      requestSent: json['request_sent'] as bool?,
      requestReceived: json['request_received'] as bool?,
      areFriends: json['are_friends'] as bool?,
      imageFullPath: json['image_fullpath'] as String?,
      posts: (json['posts'] as List<dynamic>?)
          ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      mutualFriends: (json['mutualFriends'] as List<dynamic>?)
          ?.map((e) => MutualFriend.fromJson(e as Map<String, dynamic>))
          .toList(),
      friendshipID: (json['friendship_id'] as num?)?.toInt(),
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
      'blocked': instance.blocked,
      'request_sent': instance.requestSent,
      'request_received': instance.requestReceived,
      'are_friends': instance.areFriends,
      'friendship_id': instance.friendshipID,
      'image_fullpath': instance.imageFullPath,
      'posts': instance.posts,
      'mutualFriends': instance.mutualFriends,
    };

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      content: json['content'] as List<dynamic>?,
      userId: (json['user_id'] as num?)?.toInt(),
      groupId: (json['group_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      groups: json['groups'] == null
          ? null
          : Group.fromJson(json['groups'] as Map<String, dynamic>),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => Like.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'user_id': instance.userId,
      'group_id': instance.groupId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'groups': instance.groups,
      'comments': instance.comments,
      'likes': instance.likes,
    };

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
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
      'user_id': instance.userId,
      'active': instance.active,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: (json['id'] as num?)?.toInt(),
      comment: json['comment'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      postId: (json['post_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      users: json['users'] == null
          ? null
          : CommentUser.fromJson(json['users'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'user_id': instance.userId,
      'post_id': instance.postId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'users': instance.users,
    };

Like _$LikeFromJson(Map<String, dynamic> json) => Like(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      likeableType: json['likeable_type'] as String?,
      likeableId: (json['likeable_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      users: json['users'] == null
          ? null
          : LikeUser.fromJson(json['users'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LikeToJson(Like instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'likeable_type': instance.likeableType,
      'likeable_id': instance.likeableId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'users': instance.users,
    };

CommentUser _$CommentUserFromJson(Map<String, dynamic> json) => CommentUser(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['f_name'] as String?,
      lastName: json['l_name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      isPhoneVerified: (json['is_phone_verified'] as num?)?.toInt(),
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      emailVerificationToken: json['email_verification_token'] as String?,
      phone: json['phone'] as String?,
      cmFirebaseToken: json['cm_firebase_token'] as String?,
      temporaryToken: json['temporary_token'] as String?,
      loginHitCount: (json['login_hit_count'] as num?)?.toInt(),
      isTempBlocked: (json['is_temp_blocked'] as num?)?.toInt(),
      tempBlockTime: json['temp_block_time'] as String?,
      loginMedium: json['login_medium'] as String?,
      imageFullPath: json['image_fullpath'] as String?,
    );

Map<String, dynamic> _$CommentUserToJson(CommentUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'f_name': instance.firstName,
      'l_name': instance.lastName,
      'email': instance.email,
      'image': instance.image,
      'is_phone_verified': instance.isPhoneVerified,
      'email_verified_at': instance.emailVerifiedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'email_verification_token': instance.emailVerificationToken,
      'phone': instance.phone,
      'cm_firebase_token': instance.cmFirebaseToken,
      'temporary_token': instance.temporaryToken,
      'login_hit_count': instance.loginHitCount,
      'is_temp_blocked': instance.isTempBlocked,
      'temp_block_time': instance.tempBlockTime,
      'login_medium': instance.loginMedium,
      'image_fullpath': instance.imageFullPath,
    };

LikeUser _$LikeUserFromJson(Map<String, dynamic> json) => LikeUser(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['f_name'] as String?,
      lastName: json['l_name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      isPhoneVerified: (json['is_phone_verified'] as num?)?.toInt(),
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      emailVerificationToken: json['email_verification_token'] as String?,
      phone: json['phone'] as String?,
      cmFirebaseToken: json['cm_firebase_token'] as String?,
      temporaryToken: json['temporary_token'] as String?,
      loginHitCount: (json['login_hit_count'] as num?)?.toInt(),
      isTempBlocked: (json['is_temp_blocked'] as num?)?.toInt(),
      tempBlockTime: json['temp_block_time'] as String?,
      loginMedium: json['login_medium'] as String?,
      imageFullPath: json['image_fullpath'] as String?,
    );

Map<String, dynamic> _$LikeUserToJson(LikeUser instance) => <String, dynamic>{
      'id': instance.id,
      'f_name': instance.firstName,
      'l_name': instance.lastName,
      'email': instance.email,
      'image': instance.image,
      'is_phone_verified': instance.isPhoneVerified,
      'email_verified_at': instance.emailVerifiedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'email_verification_token': instance.emailVerificationToken,
      'phone': instance.phone,
      'cm_firebase_token': instance.cmFirebaseToken,
      'temporary_token': instance.temporaryToken,
      'login_hit_count': instance.loginHitCount,
      'is_temp_blocked': instance.isTempBlocked,
      'temp_block_time': instance.tempBlockTime,
      'login_medium': instance.loginMedium,
      'image_fullpath': instance.imageFullPath,
    };

MutualFriend _$MutualFriendFromJson(Map<String, dynamic> json) => MutualFriend(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['f_name'] as String?,
      lastName: json['l_name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      isPhoneVerified: (json['is_phone_verified'] as num?)?.toInt(),
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      emailVerificationToken: json['email_verification_token'] as String?,
      phone: json['phone'] as String?,
      cmFirebaseToken: json['cm_firebase_token'] as String?,
      temporaryToken: json['temporary_token'] as String?,
      loginHitCount: (json['login_hit_count'] as num?)?.toInt(),
      isTempBlocked: (json['is_temp_blocked'] as num?)?.toInt(),
      tempBlockTime: json['temp_block_time'] as String?,
      loginMedium: json['login_medium'] as String?,
      imageFullPath: json['image_fullpath'] as String?,
    );

Map<String, dynamic> _$MutualFriendToJson(MutualFriend instance) =>
    <String, dynamic>{
      'id': instance.id,
      'f_name': instance.firstName,
      'l_name': instance.lastName,
      'email': instance.email,
      'image': instance.image,
      'is_phone_verified': instance.isPhoneVerified,
      'email_verified_at': instance.emailVerifiedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'email_verification_token': instance.emailVerificationToken,
      'phone': instance.phone,
      'cm_firebase_token': instance.cmFirebaseToken,
      'temporary_token': instance.temporaryToken,
      'login_hit_count': instance.loginHitCount,
      'is_temp_blocked': instance.isTempBlocked,
      'temp_block_time': instance.tempBlockTime,
      'login_medium': instance.loginMedium,
      'image_fullpath': instance.imageFullPath,
    };
