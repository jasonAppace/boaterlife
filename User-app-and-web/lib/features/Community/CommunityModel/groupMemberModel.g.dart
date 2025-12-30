// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupMemberModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) =>
    GroupMemberModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MemberData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupMemberModelToJson(GroupMemberModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

MemberData _$MemberDataFromJson(Map<String, dynamic> json) => MemberData(
      id: (json['id'] as num?)?.toInt(),
      name: json['f_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      image: json['image'] as String?,
      coverImage: json['cover_image'] as String?,
      description: json['description'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      interest: json['interest'] as String?,
      roleId: (json['role_id'] as num?)?.toInt(),
      isAdmin: (json['is_admin'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      age: json['age'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      encrypted: (json['encrypted'] as num?)?.toInt(),
      emailVerificationOtp: json['email_verification_otp'] as String?,
      emailVerificationExpiresAt:
          json['email_verification_expires_at'] as String?,
      pivot: json['pivot'] == null
          ? null
          : Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemberDataToJson(MemberData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'f_name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'image': instance.image,
      'cover_image': instance.coverImage,
      'description': instance.description,
      'gender': instance.gender,
      'dob': instance.dob,
      'interest': instance.interest,
      'role_id': instance.roleId,
      'is_admin': instance.isAdmin,
      'status': instance.status,
      'age': instance.age,
      'email_verified_at': instance.emailVerifiedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'encrypted': instance.encrypted,
      'email_verification_otp': instance.emailVerificationOtp,
      'email_verification_expires_at': instance.emailVerificationExpiresAt,
      'pivot': instance.pivot,
    };

Pivot _$PivotFromJson(Map<String, dynamic> json) => Pivot(
      groupId: (json['group_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      isAdmin: (json['is_admin'] as num?)?.toInt(),
      blocked: (json['blocked'] as num?)?.toInt(),
      exit: (json['exit'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$PivotToJson(Pivot instance) => <String, dynamic>{
      'group_id': instance.groupId,
      'user_id': instance.userId,
      'is_admin': instance.isAdmin,
      'blocked': instance.blocked,
      'exit': instance.exit,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
