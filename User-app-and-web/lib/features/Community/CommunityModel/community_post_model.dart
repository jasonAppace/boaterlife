// import 'package:json_annotation/json_annotation.dart';
//
// part 'community_post_model.g.dart';
//
// @JsonSerializable()
// class CommunityPostModel {
//   final bool? status;
//   final String? message;
//   final List<PostData>? data;
//
//   CommunityPostModel({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   factory CommunityPostModel.fromJson(Map<String, dynamic> json) =>
//       _$CommunityPostModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$CommunityPostModelToJson(this);
// }
//
// @JsonSerializable()
// class PostData {
//   final int? id;
//   @JsonKey(name: 'user_id')
//   final int? userId;
//   final String? title;
//   final String? content;
//   final String? image;
//   final String? status;
//   @JsonKey(name: 'created_at')
//   final String? createdAt;
//   @JsonKey(name: 'updated_at')
//   final String? updatedAt;
//   final UserData? user;
//   final List<LikeData>? likes;
//   final List<CommentData>? comments;
//
//   PostData({
//     this.id,
//     this.userId,
//     this.title,
//     this.content,
//     this.image,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.user,
//     this.likes,
//     this.comments,
//   });
//
//   factory PostData.fromJson(Map<String, dynamic> json) =>
//       _$PostDataFromJson(json);
//
//   Map<String, dynamic> toJson() => _$PostDataToJson(this);
// }
//
// @JsonSerializable()
// class UserData {
//   final int? id;
//   @JsonKey(name: 'f_name')
//   final String? fName;
//   @JsonKey(name: 'l_name')
//   final String? lName;
//   final String? email;
//   final String? image;
//   @JsonKey(name: 'is_phone_verified')
//   final int? isPhoneVerified;
//   @JsonKey(name: 'email_verified_at')
//   final String? emailVerifiedAt;
//   @JsonKey(name: 'created_at')
//   final String? createdAt;
//   @JsonKey(name: 'updated_at')
//   final String? updatedAt;
//   @JsonKey(name: 'email_verification_token')
//   final String? emailVerificationToken;
//   final String? phone;
//   @JsonKey(name: 'cm_firebase_token')
//   final String? cmFirebaseToken;
//   @JsonKey(name: 'temporary_token')
//   final String? temporaryToken;
//   @JsonKey(name: 'login_hit_count')
//   final int? loginHitCount;
//   @JsonKey(name: 'is_temp_blocked')
//   final int? isTempBlocked;
//   @JsonKey(name: 'temp_block_time')
//   final String? tempBlockTime;
//   @JsonKey(name: 'login_medium')
//   final String? loginMedium;
//   @JsonKey(name: 'image_fullpath')
//   final String? imageFullpath;
//
//   UserData({
//     this.id,
//     this.fName,
//     this.lName,
//     this.email,
//     this.image,
//     this.isPhoneVerified,
//     this.emailVerifiedAt,
//     this.createdAt,
//     this.updatedAt,
//     this.emailVerificationToken,
//     this.phone,
//     this.cmFirebaseToken,
//     this.temporaryToken,
//     this.loginHitCount,
//     this.isTempBlocked,
//     this.tempBlockTime,
//     this.loginMedium,
//     this.imageFullpath,
//   });
//
//   factory UserData.fromJson(Map<String, dynamic> json) =>
//       _$UserDataFromJson(json);
//
//   Map<String, dynamic> toJson() => _$UserDataToJson(this);
// }
//
// @JsonSerializable()
// class LikeData {
//   final int? id;
//   @JsonKey(name: 'post_id')
//   final int? postId;
//   @JsonKey(name: 'user_id')
//   final int? userId;
//   @JsonKey(name: 'created_at')
//   final String? createdAt;
//   @JsonKey(name: 'updated_at')
//   final String? updatedAt;
//
//   LikeData({
//     this.id,
//     this.postId,
//     this.userId,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory LikeData.fromJson(Map<String, dynamic> json) =>
//       _$LikeDataFromJson(json);
//
//   Map<String, dynamic> toJson() => _$LikeDataToJson(this);
// }
//
// @JsonSerializable()
// class CommentData {
//   final int? id;
//   @JsonKey(name: 'post_id')
//   final int? postId;
//   @JsonKey(name: 'user_id')
//   final int? userId;
//   final String? comment;
//   @JsonKey(name: 'created_at')
//   final String? createdAt;
//   @JsonKey(name: 'updated_at')
//   final String? updatedAt;
//   final UserData? user;
//
//   CommentData({
//     this.id,
//     this.postId,
//     this.userId,
//     this.comment,
//     this.createdAt,
//     this.updatedAt,
//     this.user,
//   });
//
//   factory CommentData.fromJson(Map<String, dynamic> json) =>
//       _$CommentDataFromJson(json);
//
//   Map<String, dynamic> toJson() => _$CommentDataToJson(this);
// }