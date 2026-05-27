import 'dart:io';
import 'package:dio/dio.dart';
import '../../../shared/utils/api_client.dart';

class MaterialsRepository {
  final ApiClient _apiClient;

  MaterialsRepository(this._apiClient);

  Future<Map<String, dynamic>> uploadMaterial({
    required File file,
    required String title,
    required String fileType,
    String? gradeLevel,
    String? subject,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'title': title,
      'file_type': fileType,
      if (gradeLevel != null) 'grade_level': gradeLevel,
      if (subject != null) 'subject': subject,
    });

    final response = await _apiClient.dio.post(
      '/api/materials',
      data: formData,
    );
    return response.data;
  }

  Future<List<dynamic>> getMaterials() async {
    final response = await _apiClient.dio.get('/api/materials');
    return response.data;
  }

  Future<Map<String, dynamic>> getMaterial(String id) async {
    final response = await _apiClient.dio.get('/api/materials/$id');
    return response.data;
  }

  Future<void> deleteMaterial(String id) async {
    await _apiClient.dio.delete('/api/materials/$id');
  }
}
