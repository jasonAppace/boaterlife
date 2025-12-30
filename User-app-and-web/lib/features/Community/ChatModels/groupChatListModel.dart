import 'package:json_annotation/json_annotation.dart';

part 'groupChatListModel.g.dart';

@JsonSerializable()
class GroupChatListModel {
  final String? messages;
  final List<GroupChat?>? data;
  final bool? status;

  GroupChatListModel({
    this.messages,
    this.data,
    this.status,
  });

  /// Factory method to create an instance from JSON
  factory GroupChatListModel.fromJson(Map<String, dynamic> json) =>
      _$GroupChatListModelFromJson(json);

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$GroupChatListModelToJson(this);
}

@JsonSerializable()
class GroupChat {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  @JsonKey(name: 'interest_id')
  final int? interestId;
  @JsonKey(name: 'user_id')
  final int? userId;
  final int? active;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final int? messageUnseen;
  final List<dynamic>? users;

  GroupChat({
    this.id,
    this.name,
    this.description,
    this.image,
    this.interestId,
    this.userId,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.messageUnseen,
    this.users,
  });

  factory GroupChat.fromJson(Map<String, dynamic> json) =>
      _$GroupChatFromJson(json);

  Map<String, dynamic> toJson() => _$GroupChatToJson(this);
}
