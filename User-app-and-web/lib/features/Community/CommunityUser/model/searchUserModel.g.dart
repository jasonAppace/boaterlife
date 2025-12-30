// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searchUserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUserModel _$SearchUserModelFromJson(Map<String, dynamic> json) =>
    SearchUserModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SearchUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$SearchUserModelToJson(SearchUserModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };

SearchUser _$SearchUserFromJson(Map<String, dynamic> json) => SearchUser(
      id: (json['id'] as num?)?.toInt(),
      name: json['f_name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$SearchUserToJson(SearchUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'f_name': instance.name,
      'email': instance.email,
      'image': instance.image,
    };
