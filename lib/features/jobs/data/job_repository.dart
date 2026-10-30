import '../../../core/network/api_client.dart';

class JobRepository {
  const JobRepository(this._api);

  final ApiClient _api;

  Future<List<dynamic>> listJobs({
    String? status,
    int limit = 50,
    int offset = 0,
  }) async =>
      (await _api.get<List<dynamic>>(
        'jobs',
        queryParameters: {
          if (status != null) 'status': status,
          'limit': limit,
          'offset': offset,
        },
      )).data ??
      (throw const FormatException('Gateway returned no jobs response.'));

  Future<Map<String, dynamic>> start(String id) async =>
      _jobAction(id, 'start');

  Future<Map<String, dynamic>> pause(String id) async =>
      _jobAction(id, 'pause');

  Future<Map<String, dynamic>> resume(String id) async =>
      _jobAction(id, 'resume');

  Future<Map<String, dynamic>> complete(String id, {String? notes}) async =>
      (await _api.post<Map<String, dynamic>>(
        'jobs/$id/complete',
        data: {if (notes != null) 'notes': notes},
      )).data ??
      (throw const FormatException('Gateway returned no job response.'));

  Future<Map<String, dynamic>> _jobAction(String id, String action) async =>
      (await _api.post<Map<String, dynamic>>('jobs/$id/$action')).data ??
      (throw const FormatException('Gateway returned no job response.'));
}

