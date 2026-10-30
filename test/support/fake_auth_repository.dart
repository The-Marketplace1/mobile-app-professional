import 'package:professional_app/core/network/api_client.dart';
import 'package:professional_app/core/storage/session_store.dart';
import 'package:professional_app/features/auth/data/auth_repository.dart';

class FakeSessionStore implements SessionStore {
  String? accessToken;
  String? refreshToken;

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> writeTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}

class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository()
    : super(
        apiClient: ApiClient(sessionStorage: FakeSessionStore()),
        sessionStore: FakeSessionStore(),
      );

  @override
  Future<bool> restoreSession() async => false;
}

