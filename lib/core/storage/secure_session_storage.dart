import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'session_store.dart';

class SecureSessionStorage implements SessionStore {
  const SecureSessionStorage(this._storage);

    final FlutterSecureStorage _storage;

      static const accessTokenKey = 'professional.access_token';
        static const refreshTokenKey = 'professional.refresh_token';

	  @override
	    Future<String?> readAccessToken() => _storage.read(key: accessTokenKey);

	      @override
	        Future<String?> readRefreshToken() => _storage.read(key: refreshTokenKey);

		  @override
		    Future<void> writeTokens({
		        required String accessToken,
			    String? refreshToken,
			      }) async {
			          await _storage.write(key: accessTokenKey, value: accessToken);
				      if (refreshToken != null) {
				            await _storage.write(key: refreshTokenKey, value: refreshToken);
					        }
						  }

						    @override
						      Future<void> clear() async {
						          await _storage.delete(key: accessTokenKey);
							      await _storage.delete(key: refreshTokenKey);
							        }
								}

