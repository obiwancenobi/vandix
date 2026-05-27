import 'package:freezed_annotation/freezed_annotation.dart';

part 'material_model.freezed.dart';
part 'material_model.g.dart';

@freezed
class MaterialModel with _$MaterialModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MaterialModel({
    required String id,
    required String title,
    String? description,
    required String fileType,
    required String status,
    String? subject,
    String? gradeLevel,
    String? extractedText,
    required DateTime createdAt,
  }) = _MaterialModel;

  factory MaterialModel.fromJson(Map<String, dynamic> json) => _$MaterialModelFromJson(json);
}
