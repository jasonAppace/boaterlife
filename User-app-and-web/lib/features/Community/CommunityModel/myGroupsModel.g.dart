// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myGroupsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyGroupsModel _$MyGroupsModelFromJson(Map<String, dynamic> json) =>
    MyGroupsModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MyGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyGroupsModelToJson(MyGroupsModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

MyGroup _$MyGroupFromJson(Map<String, dynamic> json) => MyGroup(
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

Map<String, dynamic> _$MyGroupToJson(MyGroup instance) => <String, dynamic>{
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
