import '../../../core/network/api_client.dart';

class EarningsRepository {
  const EarningsRepository(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> getSummary() async =>
      (await _api.get<Map<String, dynamic>>(
        'payments/earnings-summary',
      )).data ??
      <String, dynamic>{};

  Future<List<dynamic>> listPayments({int limit = 50, int offset = 0}) async =>
      (await _api.get<List<dynamic>>(
        'payments',
        queryParameters: {'limit': limit, 'offset': offset},
      )).data ??
      const [];

  Future<List<dynamic>> listEscrow() async =>
      (await _api.get<List<dynamic>>('payments/escrow')).data ?? const [];

  Future<List<dynamic>> getEarningsChart({String period = 'month'}) async =>
      (await _api.get<List<dynamic>>(
        'analytics/earnings-chart',
        queryParameters: {'period': period},
      )).data ??
      const [];
}

