import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:professional_app/core/network/api_client.dart';
import 'package:professional_app/core/storage/session_store.dart';

void main() {
  test(
    'refreshes an expired access token once and retries the request',
    () async {
      final storage = _MemorySessionStore()
        ..accessToken = 'expired-access'
        ..refreshToken = 'valid-refresh';
      final adapter = _RefreshAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://gateway.test/api/v1/'))
        ..httpClientAdapter = adapter;
      final client = ApiClient(sessionStorage: storage, dio: dio);

      final response = await client.get<Map<String, dynamic>>('private');

      expect(response.data?['ok'], isTrue);
      expect(adapter.privateAuthorization, [
        'Bearer expired-access',
        'Bearer new-access',
      ]);
      expect(storage.accessToken, 'new-access');
      expect(storage.refreshToken, 'next-refresh');
    },
  );
}

class _RefreshAdapter implements HttpClientAdapter {
  final privateAuthorization = <String?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.uri.path;
    if (path.endsWith('/private')) {
      privateAuthorization.add(options.headers['Authorization'] as String?);
      if (options.headers['Authorization'] == 'Bearer expired-access') {
        return _jsonResponse(401, {'message': 'expired'});
      }
      return _jsonResponse(200, {'ok': true});
    }
    if (path.endsWith('/auth/refresh')) {
      return _jsonResponse(200, {
        'accessToken': 'new-access',
        'refreshToken': 'next-refresh',
        'tokenType': 'Bearer',
      });
    }
    return _jsonResponse(404, {'message': 'not found'});
  }

  ResponseBody _jsonResponse(int statusCode, Map<String, Object?> body) =>
      ResponseBody.fromString(
        jsonEncode(body),
        statusCode,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  void close({bool force = false}) {}
}

class _MemorySessionStore implements SessionStore {
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

