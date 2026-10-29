class AppConfig {
  const AppConfig._();

    /// Include the Gateway API version prefix in the configured URL.
      static const apiGatewayUrl = String.fromEnvironment('API_GATEWAY_URL');
        static const realtimeUrl = String.fromEnvironment('REALTIME_SERVICE_URL');
	  static const mapboxPublicToken = String.fromEnvironment(
	      'MAPBOX_PUBLIC_TOKEN',
	        );

		  static bool get isApiConfigured => apiGatewayUrl.trim().isNotEmpty;
		    static bool get isRealtimeConfigured => realtimeUrl.trim().isNotEmpty;
		    }

