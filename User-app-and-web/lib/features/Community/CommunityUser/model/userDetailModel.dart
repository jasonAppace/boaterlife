import 'package:json_annotation/json_annotation.dart';

part 'userDetailModel.g.dart';

@JsonSerializable()
class UserDetailModel {
  final String? message;
  final UserData? data;
  final bool? status;

  UserDetailModel({
    this.message,
    this.data,
    this.status,
  });

  /// Factory method to create an instance from JSON
  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      _$UserDetailModelFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$UserDetailModelToJson(this);
}

@JsonSerializable()
class UserData {
  final int? id;
  @JsonKey(name: 'f_name')
  final String? firstName;
  @JsonKey(name: 'l_name')
  final String? lastName;
  final String? email;
  final String? phone;
  final String? image;
  @JsonKey(name: 'is_phone_verified')
  final int? isPhoneVerified;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'email_verification_token')
  final String? emailVerificationToken;
  @JsonKey(name: 'cm_firebase_token')
  final String? cmFirebaseToken;
  @JsonKey(name: 'temporary_token')
  final String? temporaryToken;
  @JsonKey(name: 'login_hit_count')
  final int? loginHitCount;
  @JsonKey(name: 'is_temp_blocked')
  final int? isTempBlocked;
  @JsonKey(name: 'temp_block_time')
  final String? tempBlockTime;
  @JsonKey(name: 'login_medium')
  final String? loginMedium;
  final bool? blocked;
  @JsonKey(name: 'request_sent')
  final bool? requestSent;
  @JsonKey(name: 'request_received')
  final bool? requestReceived;
  @JsonKey(name: 'are_friends')
  final bool? areFriends;
  @JsonKey(name: 'friendship_id')
  final int? friendshipID;
  @JsonKey(name: 'image_fullpath')
  final String? imageFullPath;

  // New fields added based on the updated response
  final List<Post>? posts;
  @JsonKey(name: 'mutualFriends')
  final List<MutualFriend>? mutualFriends;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.image,
    this.isPhoneVerified,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.emailVerificationToken,
    this.cmFirebaseToken,
    this.temporaryToken,
    this.loginHitCount,
    this.isTempBlocked,
    this.tempBlockTime,
    this.loginMedium,
    this.blocked,
    this.requestSent,
    this.requestReceived,
    this.areFriends,
    this.imageFullPath,
    this.posts,
    this.mutualFriends,
    this.friendshipID
  });

  /// Factory method to create an instance from JSON
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class Post {
  final int? id;
  final String? title;
  final String? description;
  final List<dynamic>? content;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'group_id')
  final int? groupId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final Group? groups;
  final List<Comment>? comments;
  final List<Like>? likes;

  Post({
    this.id,
    this.title,
    this.description,
    this.content,
    this.userId,
    this.groupId,
    this.createdAt,
    this.updatedAt,
    this.groups,
    this.comments,
    this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class Group {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
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
    this.userId,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable()
class Comment {
  final int? id;
  final String? comment;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'post_id')
  final int? postId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final CommentUser? users;

  Comment({
    this.id,
    this.comment,
    this.userId,
    this.postId,
    this.createdAt,
    this.updatedAt,
    this.users,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@JsonSerializable()
class Like {
  final int? id;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'likeable_type')
  final String? likeableType;
  @JsonKey(name: 'likeable_id')
  final int? likeableId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final LikeUser? users;

  Like({
    this.id,
    this.userId,
    this.likeableType,
    this.likeableId,
    this.createdAt,
    this.updatedAt,
    this.users,
  });

  factory Like.fromJson(Map<String, dynamic> json) => _$LikeFromJson(json);
  Map<String, dynamic> toJson() => _$LikeToJson(this);
}

@JsonSerializable()
class CommentUser {
  final int? id;
  @JsonKey(name: 'f_name')
  final String? firstName;
  @JsonKey(name: 'l_name')
  final String? lastName;
  final String? email;
  final String? image;
  @JsonKey(name: 'is_phone_verified')
  final int? isPhoneVerified;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'email_verification_token')
  final String? emailVerificationToken;
  final String? phone;
  @JsonKey(name: 'cm_firebase_token')
  final String? cmFirebaseToken;
  @JsonKey(name: 'temporary_token')
  final String? temporaryToken;
  @JsonKey(name: 'login_hit_count')
  final int? loginHitCount;
  @JsonKey(name: 'is_temp_blocked')
  final int? isTempBlocked;
  @JsonKey(name: 'temp_block_time')
  final String? tempBlockTime;
  @JsonKey(name: 'login_medium')
  final String? loginMedium;
  @JsonKey(name: 'image_fullpath')
  final String? imageFullPath;

  CommentUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.isPhoneVerified,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.emailVerificationToken,
    this.phone,
    this.cmFirebaseToken,
    this.temporaryToken,
    this.loginHitCount,
    this.isTempBlocked,
    this.tempBlockTime,
    this.loginMedium,
    this.imageFullPath,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) => _$CommentUserFromJson(json);
  Map<String, dynamic> toJson() => _$CommentUserToJson(this);
}

@JsonSerializable()
class LikeUser {
  final int? id;
  @JsonKey(name: 'f_name')
  final String? firstName;
  @JsonKey(name: 'l_name')
  final String? lastName;
  final String? email;
  final String? image;
  @JsonKey(name: 'is_phone_verified')
  final int? isPhoneVerified;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'email_verification_token')
  final String? emailVerificationToken;
  final String? phone;
  @JsonKey(name: 'cm_firebase_token')
  final String? cmFirebaseToken;
  @JsonKey(name: 'temporary_token')
  final String? temporaryToken;
  @JsonKey(name: 'login_hit_count')
  final int? loginHitCount;
  @JsonKey(name: 'is_temp_blocked')
  final int? isTempBlocked;
  @JsonKey(name: 'temp_block_time')
  final String? tempBlockTime;
  @JsonKey(name: 'login_medium')
  final String? loginMedium;
  @JsonKey(name: 'image_fullpath')
  final String? imageFullPath;

  LikeUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.isPhoneVerified,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.emailVerificationToken,
    this.phone,
    this.cmFirebaseToken,
    this.temporaryToken,
    this.loginHitCount,
    this.isTempBlocked,
    this.tempBlockTime,
    this.loginMedium,
    this.imageFullPath,
  });

  factory LikeUser.fromJson(Map<String, dynamic> json) => _$LikeUserFromJson(json);
  Map<String, dynamic> toJson() => _$LikeUserToJson(this);
}

@JsonSerializable()
class MutualFriend {
  final int? id;
  @JsonKey(name: 'f_name')
  final String? firstName;
  @JsonKey(name: 'l_name')
  final String? lastName;
  final String? email;
  final String? image;
  @JsonKey(name: 'is_phone_verified')
  final int? isPhoneVerified;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'email_verification_token')
  final String? emailVerificationToken;
  final String? phone;
  @JsonKey(name: 'cm_firebase_token')
  final String? cmFirebaseToken;
  @JsonKey(name: 'temporary_token')
  final String? temporaryToken;
  @JsonKey(name: 'login_hit_count')
  final int? loginHitCount;
  @JsonKey(name: 'is_temp_blocked')
  final int? isTempBlocked;
  @JsonKey(name: 'temp_block_time')
  final String? tempBlockTime;
  @JsonKey(name: 'login_medium')
  final String? loginMedium;
  @JsonKey(name: 'image_fullpath')
  final String? imageFullPath;

  MutualFriend({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.isPhoneVerified,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.emailVerificationToken,
    this.phone,
    this.cmFirebaseToken,
    this.temporaryToken,
    this.loginHitCount,
    this.isTempBlocked,
    this.tempBlockTime,
    this.loginMedium,
    this.imageFullPath,
  });

  factory MutualFriend.fromJson(Map<String, dynamic> json) => _$MutualFriendFromJson(json);
  Map<String, dynamic> toJson() => _$MutualFriendToJson(this);
}