import '../../../core/network/api_client.dart';

class BookingRepository {
  const BookingRepository(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> listBookings({
    String? status,
    String? from,
    String? to,
    int limit = 50,
    int offset = 0,
  }) async =>
      (await _api.get<Map<String, dynamic>>(
        'bookings',
        queryParameters: {
          if (status != null) 'status': status,
          if (from != null) 'from': from,
          if (to != null) 'to': to,
          'limit': limit,
          'offset': offset,
        },
      )).data ??
      (throw const FormatException('Gateway returned no bookings response.'));

  Future<Map<String, dynamic>> accept(String id) async =>
      (await _api.post<Map<String, dynamic>>('bookings/$id/accept')).data ??
      (throw const FormatException('Gateway returned no booking response.'));

  Future<Map<String, dynamic>> decline({
    required String id,
    required String reason,
  }) async =>
      (await _api.post<Map<String, dynamic>>(
        'bookings/$id/decline',
        data: {'reason': reason},
      )).data ??
      (throw const FormatException('Gateway returned no booking response.'));

  Future<Map<String, dynamic>> reschedule({
    required String id,
    required DateTime proposedAt,
    String? message,
  }) async =>
      (await _api.post<Map<String, dynamic>>(
        'bookings/$id/reschedule',
        data: {
          'proposedAt': proposedAt.toIso8601String(),
          if (message != null) 'message': message,
        },
      )).data ??
      (throw const FormatException('Gateway returned no booking response.'));
}

