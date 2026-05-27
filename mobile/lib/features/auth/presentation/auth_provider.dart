import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/utils/api_client.dart';
import '../data/auth_repository.dart';
import '../domain/user.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

final authStateProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final api = ref.read(apiClientProvider);
    final hasToken = await api.hasToken();
    if (!hasToken) return null;

    try {
      final repo = ref.read(authRepositoryProvider);
      final data = await repo.getMe();
      return User.fromJson(data);
    } catch (_) {
      await api.clearTokens();
      return null;
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final data = await repo.login(email: email, password: password);
      final api = ref.read(apiClientProvider);
      await api.saveTokens(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
      );
      final userData = await repo.getMe();
      return User.fromJson(userData);
    });
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final data = await repo.register(
        name: name,
        email: email,
        password: password,
        referralCode: referralCode,
      );
      final api = ref.read(apiClientProvider);
      await api.saveTokens(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
      );
      final userData = await repo.getMe();
      return User.fromJson(userData);
    });
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncValue.data(null);
  }
}
