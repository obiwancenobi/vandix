// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'material_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MaterialModel _$MaterialModelFromJson(Map<String, dynamic> json) {
  return _MaterialModel.fromJson(json);
}

/// @nodoc
mixin _$MaterialModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get fileType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get subject => throw _privateConstructorUsedError;
  String? get gradeLevel => throw _privateConstructorUsedError;
  String? get extractedText => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MaterialModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaterialModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaterialModelCopyWith<MaterialModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaterialModelCopyWith<$Res> {
  factory $MaterialModelCopyWith(
    MaterialModel value,
    $Res Function(MaterialModel) then,
  ) = _$MaterialModelCopyWithImpl<$Res, MaterialModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    String fileType,
    String status,
    String? subject,
    String? gradeLevel,
    String? extractedText,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MaterialModelCopyWithImpl<$Res, $Val extends MaterialModel>
    implements $MaterialModelCopyWith<$Res> {
  _$MaterialModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaterialModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? fileType = null,
    Object? status = null,
    Object? subject = freezed,
    Object? gradeLevel = freezed,
    Object? extractedText = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileType: null == fileType
                ? _value.fileType
                : fileType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            subject: freezed == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String?,
            gradeLevel: freezed == gradeLevel
                ? _value.gradeLevel
                : gradeLevel // ignore: cast_nullable_to_non_nullable
                      as String?,
            extractedText: freezed == extractedText
                ? _value.extractedText
                : extractedText // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MaterialModelImplCopyWith<$Res>
    implements $MaterialModelCopyWith<$Res> {
  factory _$$MaterialModelImplCopyWith(
    _$MaterialModelImpl value,
    $Res Function(_$MaterialModelImpl) then,
  ) = __$$MaterialModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    String fileType,
    String status,
    String? subject,
    String? gradeLevel,
    String? extractedText,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MaterialModelImplCopyWithImpl<$Res>
    extends _$MaterialModelCopyWithImpl<$Res, _$MaterialModelImpl>
    implements _$$MaterialModelImplCopyWith<$Res> {
  __$$MaterialModelImplCopyWithImpl(
    _$MaterialModelImpl _value,
    $Res Function(_$MaterialModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MaterialModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? fileType = null,
    Object? status = null,
    Object? subject = freezed,
    Object? gradeLevel = freezed,
    Object? extractedText = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$MaterialModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileType: null == fileType
            ? _value.fileType
            : fileType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        subject: freezed == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String?,
        gradeLevel: freezed == gradeLevel
            ? _value.gradeLevel
            : gradeLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        extractedText: freezed == extractedText
            ? _value.extractedText
            : extractedText // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MaterialModelImpl implements _MaterialModel {
  const _$MaterialModelImpl({
    required this.id,
    required this.title,
    this.description,
    required this.fileType,
    required this.status,
    this.subject,
    this.gradeLevel,
    this.extractedText,
    required this.createdAt,
  });

  factory _$MaterialModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaterialModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String fileType;
  @override
  final String status;
  @override
  final String? subject;
  @override
  final String? gradeLevel;
  @override
  final String? extractedText;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MaterialModel(id: $id, title: $title, description: $description, fileType: $fileType, status: $status, subject: $subject, gradeLevel: $gradeLevel, extractedText: $extractedText, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaterialModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.extractedText, extractedText) ||
                other.extractedText == extractedText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    fileType,
    status,
    subject,
    gradeLevel,
    extractedText,
    createdAt,
  );

  /// Create a copy of MaterialModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaterialModelImplCopyWith<_$MaterialModelImpl> get copyWith =>
      __$$MaterialModelImplCopyWithImpl<_$MaterialModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaterialModelImplToJson(this);
  }
}

abstract class _MaterialModel implements MaterialModel {
  const factory _MaterialModel({
    required final String id,
    required final String title,
    final String? description,
    required final String fileType,
    required final String status,
    final String? subject,
    final String? gradeLevel,
    final String? extractedText,
    required final DateTime createdAt,
  }) = _$MaterialModelImpl;

  factory _MaterialModel.fromJson(Map<String, dynamic> json) =
      _$MaterialModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get fileType;
  @override
  String get status;
  @override
  String? get subject;
  @override
  String? get gradeLevel;
  @override
  String? get extractedText;
  @override
  DateTime get createdAt;

  /// Create a copy of MaterialModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaterialModelImplCopyWith<_$MaterialModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
