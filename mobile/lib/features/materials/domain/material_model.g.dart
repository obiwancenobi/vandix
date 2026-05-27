// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaterialModelImpl _$$MaterialModelImplFromJson(Map<String, dynamic> json) =>
    _$MaterialModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      fileType: json['fileType'] as String,
      status: json['status'] as String,
      subject: json['subject'] as String?,
      gradeLevel: json['gradeLevel'] as String?,
      extractedText: json['extractedText'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MaterialModelImplToJson(_$MaterialModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'fileType': instance.fileType,
      'status': instance.status,
      'subject': instance.subject,
      'gradeLevel': instance.gradeLevel,
      'extractedText': instance.extractedText,
      'createdAt': instance.createdAt.toIso8601String(),
    };
