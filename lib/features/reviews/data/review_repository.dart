import '../../../core/network/api_client.dart';

class ReviewRepository {
  const ReviewRepository(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> listReviews({
    int limit = 50,
    int offset = 0,
  }) async =>
      (await _api.get<Map<String, dynamic>>(
        'reviews',
        queryParameters: {'limit': limit, 'offset': offset},
      )).data ??
      <String, dynamic>{};

  Future<Map<String, dynamic>> getStats() async =>
      (await _api.get<Map<String, dynamic>>('reviews/stats')).data ??
      <String, dynamic>{};

  Future<Map<String, dynamic>> respond({
    required String reviewId,
    required String response,
  }) async =>
      (await _api.post<Map<String, dynamic>>(
        'reviews/$reviewId/respond',
        data: {'response': response.trim()},
      )).data ??
      <String, dynamic>{};
}

