import '../../../core/network/api_client.dart';

class SettingsRepository {
  const SettingsRepository(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> getNotificationPreferences() async =>
      (await _api.get<Map<String, dynamic>>(
        'notifications/preferences',
      )).data ??
      <String, dynamic>{};

  Future<Map<String, dynamic>> updateNotificationPreferences(
    Map<String, dynamic> preferences,
  ) async =>
      (await _api.put<Map<String, dynamic>>(
        'notifications/preferences',
        data: preferences,
      )).data ??
      <String, dynamic>{};

  Future<void> markNotificationRead(String id) async {
    await _api.post<void>('notifications/$id/read');
  }

  Future<void> markAllNotificationsRead() async {
    await _api.post<void>('notifications/read-all');
  }
}

