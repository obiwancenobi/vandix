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
      fileType: json['file_type'] as String,
      status: json['status'] as String,
      subject: json['subject'] as String?,
      gradeLevel: json['grade_level'] as String?,
      extractedText: json['extracted_text'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$MaterialModelImplToJson(_$MaterialModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'file_type': instance.fileType,
      'status': instance.status,
      'subject': instance.subject,
      'grade_level': instance.gradeLevel,
      'extracted_text': instance.extractedText,
      'created_at': instance.createdAt.toIso8601String(),
    };
