import '../../../core/network/api_client.dart';

class ProfileRepository {
  const ProfileRepository(this._api);

    final ApiClient _api;

      Future<Map<String, dynamic>> getProfile() async =>
            (await _api.get<Map<String, dynamic>>('profile')).data ??
	          <String, dynamic>{};

		    Future<Map<String, dynamic>> updateProfile(
		        Map<String, dynamic> changes,
			  ) async =>
			        (await _api.patch<Map<String, dynamic>>('profile', data: changes)).data ??
				      <String, dynamic>{};
				      }

