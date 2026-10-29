import '../../../core/network/api_client.dart';

class ServiceRepository {
  const ServiceRepository(this._api);

    final ApiClient _api;

      Future<List<dynamic>> listServices() async =>
            (await _api.get<List<dynamic>>('services')).data ?? const [];

	      Future<Map<String, dynamic>> createService(
	          Map<String, dynamic> service,
		    ) async =>
		          (await _api.post<Map<String, dynamic>>('services', data: service)).data ??
			        <String, dynamic>{};

				  Future<Map<String, dynamic>> updateService(
				      String id,
				          Map<String, dynamic> changes,
					    ) async =>
					          (await _api.patch<Map<String, dynamic>>(
						          'services/$id',
							          data: changes,
								        )).data ??
									      <String, dynamic>{};

									        Future<void> deleteService(String id) async {
										    await _api.delete<void>('services/$id');
										      }
										      }

