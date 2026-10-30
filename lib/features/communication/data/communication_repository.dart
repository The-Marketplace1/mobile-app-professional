import '../../../core/network/api_client.dart';

class CommunicationRepository {
  const CommunicationRepository(this._api);

  final ApiClient _api;

  Future<List<dynamic>> listConversations() async =>
      (await _api.get<List<dynamic>>('conversations')).data ?? const [];

  Future<Map<String, dynamic>> getConversation(String id) async =>
      (await _api.get<Map<String, dynamic>>('conversations/$id')).data ??
      <String, dynamic>{};

  Future<List<dynamic>> listMessages(String conversationId) async =>
      (await _api.get<List<dynamic>>(
        'conversations/$conversationId/messages',
      )).data ??
      const [];

  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String content,
  }) async =>
      (await _api.post<Map<String, dynamic>>(
        'conversations/$conversationId/messages',
        data: {'content': content.trim()},
      )).data ??
      <String, dynamic>{};

  Future<void> markConversationRead(String conversationId) async {
    await _api.post<void>('conversations/$conversationId/read');
  }

  Future<List<dynamic>> listCallHistory() async =>
      (await _api.get<List<dynamic>>('calls')).data ?? const [];
}

