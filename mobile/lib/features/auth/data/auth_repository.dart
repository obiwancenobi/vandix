import '../../../shared/utils/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    final response = await _apiClient.dio.post('/api/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      if (referralCode != null) 'referral_code': referralCode,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.dio.post('/api/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> googleAuth(String token) async {
    final response = await _apiClient.dio.post('/api/auth/google', data: {
      'token': token,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _apiClient.dio.get('/api/auth/me');
    return response.data;
  }

  Future<void> logout() async {
    await _apiClient.clearTokens();
  }
}
