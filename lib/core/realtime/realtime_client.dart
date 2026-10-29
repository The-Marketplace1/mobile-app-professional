import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../config/app_config.dart';

class RealtimeClient {
  WebSocketChannel? _channel;
    final _events = StreamController<Map<String, dynamic>>.broadcast();

      Stream<Map<String, dynamic>> get events => _events.stream;
        bool get isConfigured => AppConfig.realtimeUrl.isNotEmpty;

	  Future<void> connect() async {
	      if (!isConfigured) return;
	          _channel = WebSocketChannel.connect(Uri.parse(AppConfig.realtimeUrl));
		      await _channel!.ready;
		          _channel!.stream.listen((message) {
			        if (message is String) {
				        final decoded = jsonDecode(message);
					        if (decoded is Map<String, dynamic>) _events.add(decoded);
						      }
						          });
							    }

							      void send(String event, Map<String, dynamic> payload) {
							          if (_channel == null) return;
								      _channel!.sink.add(jsonEncode({'event': event, 'payload': payload}));
								        }

									  Future<void> dispose() async {
									      await _channel?.sink.close();
									          await _events.close();
										    }
										    }

