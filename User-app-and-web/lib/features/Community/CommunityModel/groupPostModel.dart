import 'package:json_annotation/json_annotation.dart';

part 'groupPostModel.g.dart';

@JsonSerializable()
class GroupPostModel {
  final bool? status;
  final String? message;
  @JsonKey(name: 'data')
  final DataWrapper? paginatedData;

  // For backward compatibility with existing UI code
  List<PostData>? get data => paginatedData?.data;

  GroupPostModel({this.status, this.message, this.paginatedData});

  factory GroupPostModel.fromJson(Map<String, dynamic> json) =>
      _$GroupPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupPostModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  final List<PostData>? data;
  final String? path;
  @JsonKey(name: 'per_page')
  final int? perPage;
  @JsonKey(name: 'next_cursor')
  final String? nextCursor;
  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;
  @JsonKey(name: 'prev_cursor')
  final String? prevCursor;
  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;

  DataWrapper({
    this.data,
    this.path,
    this.perPage,
    this.nextCursor,
    this.nextPageUrl,
    this.prevCursor,
    this.prevPageUrl,
  });

  factory DataWrapper.fromJson(Map<String, dynamic> json) =>
      _$DataWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}

@JsonSerializable()
class PostData {
  final int? id;
  final String? title;
  final String? description;
  final List<String>? content;
  final String? status;
  @JsonKey(name: 'is_flagged')
  final int? isFlagged;
  @JsonKey(name: 'moderation_reason')
  final String? moderationReason;
  @JsonKey(name: 'moderated_by')
  final String? moderatedBy;
  @JsonKey(name: 'moderated_at')
  final String? moderatedAt;
  @JsonKey(name: 'moderation_notes')
  final String? moderationNotes;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'group_id')
  final int? groupId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final UserData? users;
  final GroupData? groups;
  final List<CommentData>? comments;
  final List<LikeData>? likes;

  PostData({
    this.id,
    this.title,
    this.description,
    this.content,
    this.status,
    this.isFlagged,
    this.moderationReason,
    this.moderatedBy,
    this.moderatedAt,
    this.moderationNotes,
    this.userId,
    this.groupId,
    this.createdAt,
    this.updatedAt,
    this.users,
    this.groups,
    this.comments,
    this.likes,
  });

  factory PostData.fromJson(Map<String, dynamic> json) =>
      _$PostDataFromJson(json);

  Map<String, dynamic> toJson() => _$PostDataToJson(this);
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
  @JsonKey(name: 'image_fullpath')
  final String? imageFullPath;

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
    this.imageFullPath,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class GroupData {
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
  final String? status;
  @JsonKey(name: 'is_flagged')
  final int? isFlagged;
  @JsonKey(name: 'moderation_reason')
  final String? moderationReason;
  @JsonKey(name: 'moderated_by')
  final String? moderatedBy;
  @JsonKey(name: 'moderated_at')
  final String? moderatedAt;
  @JsonKey(name: 'moderation_notes')
  final String? moderationNotes;

  GroupData({
    this.id,
    this.name,
    this.description,
    this.image,
    this.userId,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.isFlagged,
    this.moderationReason,
    this.moderatedBy,
    this.moderatedAt,
    this.moderationNotes,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) =>
      _$GroupDataFromJson(json);

  Map<String, dynamic> toJson() => _$GroupDataToJson(this);
}

@JsonSerializable()
class CommentData {
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
  final UserData? users;

  CommentData({
    this.id,
    this.comment,
    this.userId,
    this.postId,
    this.createdAt,
    this.updatedAt,
    this.users,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDataToJson(this);
}

@JsonSerializable()
class LikeData {
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
  final UserData? users;

  LikeData({
    this.id,
    this.userId,
    this.likeableType,
    this.likeableId,
    this.createdAt,
    this.updatedAt,
    this.users,
  });

  factory LikeData.fromJson(Map<String, dynamic> json) =>
      _$LikeDataFromJson(json);

  Map<String, dynamic> toJson() => _$LikeDataToJson(this);
}
