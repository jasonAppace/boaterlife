import 'package:json_annotation/json_annotation.dart';

part 'individualChatListModel.g.dart';

@JsonSerializable()
class IndividualChatListModel {
  final String? messages;
  final List<IndividualChat>? data;
  final bool? status;

  IndividualChatListModel({
    this.messages,
    this.data,
    this.status,
  });

  /// Factory method to create an instance from JSON
  factory IndividualChatListModel.fromJson(Map<String, dynamic> json) =>
      _$IndividualChatListModelFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$IndividualChatListModelToJson(this);
}

@JsonSerializable()
class IndividualChat {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? image;
  final String? coverImage;
  final String? description;
  final String? gender;
  final String? dob;
  final String? interest;
  final int? roleId;
  final int? isAdmin;
  final int? status;
  final String? age;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? encrypted;
  final String? emailVerificationOtp;
  final String? emailVerificationExpiresAt;
  final LatestMessage? latest;

  IndividualChat({
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
    this.latest,
  });

  /// Factory method to create an instance from JSON
  factory IndividualChat.fromJson(Map<String, dynamic> json) =>
      _$IndividualChatFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$IndividualChatToJson(this);
}

@JsonSerializable()
class LatestMessage {
  final int? id;
  final int? fromId;
  final int? toId;
  final String? groupId;
  final String? referenceGroupId;
  final int? replyTo;
  final String? body;
  final String? attachment;
  final int? seen;
  final String? createdAt;
  final String? updatedAt;

  LatestMessage({
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
  });

  /// Factory method to create an instance from JSON
  factory LatestMessage.fromJson(Map<String, dynamic> json) =>
      _$LatestMessageFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$LatestMessageToJson(this);
}
