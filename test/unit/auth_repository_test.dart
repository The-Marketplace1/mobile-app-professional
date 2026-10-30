import 'package:flutter_test/flutter_test.dart';
import 'package:professional_app/core/network/api_client.dart';
import 'package:professional_app/features/auth/data/auth_repository.dart';

import '../support/fake_auth_repository.dart';

void main() {
  test('sign-out clears local tokens even if Gateway is unavailable', () async {
    final store = FakeSessionStore()
      ..accessToken = 'access-token'
      ..refreshToken = 'refresh-token';
    final repository = AuthRepository(
      apiClient: ApiClient(sessionStorage: store),
      sessionStore: store,
    );

    await expectLater(
      repository.signOut(),
      throwsA(isA<ApiConfigurationException>()),
    );

    expect(store.accessToken, isNull);
    expect(store.refreshToken, isNull);
  });
}

