// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupInfoModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupInfoModel _$GroupInfoModelFromJson(Map<String, dynamic> json) =>
    GroupInfoModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : GroupData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GroupInfoModelToJson(GroupInfoModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

GroupData _$GroupDataFromJson(Map<String, dynamic> json) => GroupData(
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

Map<String, dynamic> _$GroupDataToJson(GroupData instance) => <String, dynamic>{
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
