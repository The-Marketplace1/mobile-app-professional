import '../../../core/network/api_client.dart';

class DisputeRepository {
  const DisputeRepository(this._api);

  final ApiClient _api;

  Future<List<dynamic>> listDisputes() async =>
      (await _api.get<List<dynamic>>('disputes')).data ?? const [];

  Future<Map<String, dynamic>> createDispute(
    Map<String, dynamic> request,
  ) async =>
      (await _api.post<Map<String, dynamic>>('disputes', data: request)).data ??
      <String, dynamic>{};

  Future<Map<String, dynamic>> getDispute(String id) async =>
      (await _api.get<Map<String, dynamic>>('disputes/$id')).data ??
      <String, dynamic>{};
}

