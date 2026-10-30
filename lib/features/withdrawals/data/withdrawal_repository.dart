import '../../../core/network/api_client.dart';

class WithdrawalRepository {
  const WithdrawalRepository(this._api);

  final ApiClient _api;

  Future<List<dynamic>> listWithdrawals() async =>
      (await _api.get<List<dynamic>>('withdrawals')).data ?? const [];

  Future<Map<String, dynamic>> requestWithdrawal({
    required num amount,
    String? currency,
  }) async =>
      (await _api.post<Map<String, dynamic>>(
        'withdrawals',
        data: {'amount': amount, if (currency != null) 'currency': currency},
      )).data ??
      <String, dynamic>{};

  Future<Map<String, dynamic>> getWithdrawal(String id) async =>
      (await _api.get<Map<String, dynamic>>('withdrawals/$id')).data ??
      <String, dynamic>{};
}

