import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/session_store.dart';

class ApiConfigurationException implements Exception {
  const ApiConfigurationException();

    @override
      String toString() =>
            'API Gateway is not configured. Set API_GATEWAY_URL at build time.';
	    }

	    class ApiClient {
	      ApiClient({required SessionStore sessionStorage, Dio? dio})
	          : _sessionStorage = sessionStorage,
		        _dio =
			          dio ??
				            Dio(
					                BaseOptions(
							              baseUrl: AppConfig.isApiConfigured
								                        ? '${AppConfig.apiGatewayUrl.replaceFirst(RegExp(r'/+$'), '')}/'
											                  : '',
													                connectTimeout: const Duration(seconds: 12),
															              receiveTimeout: const Duration(seconds: 20),
																                    headers: const {'Accept': 'application/json'},
																		                ),
																				          ) {
																					      _dio.interceptors.add(
																					            InterceptorsWrapper(
																						            onRequest: (options, handler) async {
																							              final token = await _sessionStorage.readAccessToken();
																								                if (token != null && token.isNotEmpty) {
																										            options.headers['Authorization'] = 'Bearer $token';
																											              }
																												                options.headers['X-Client'] = 'professional-mobile';
																														          handler.next(options);
																															          },
																																          onError: (error, handler) async {
																																	            final request = error.requestOptions;
																																		              final isUnauthorized = error.response?.statusCode == 401;
																																			                final isRefreshRequest = request.path.endsWith('auth/refresh');
																																					          final alreadyRetried = request.extra['sessionRefreshRetried'] == true;
																																						            if (!isUnauthorized || isRefreshRequest || alreadyRetried) {
																																							                handler.next(error);
																																									            return;
																																										              }

																																											                final accessToken = await _refreshAccessToken();
																																													          if (accessToken == null) {
																																														              handler.next(error);
																																															                  return;
																																																	            }
																																																		              request
																																																			                  ..headers['Authorization'] = 'Bearer $accessToken'
																																																					              ..extra['sessionRefreshRetried'] = true;
																																																						                try {
																																																								            handler.resolve(await _dio.fetch<dynamic>(request));
																																																									              } catch (retryError) {
																																																										                  handler.next(retryError is DioException ? retryError : error);
																																																												            }
																																																													            },
																																																														          ),
																																																															      );
																																																															        }

																																																																  final Dio _dio;
																																																																    final SessionStore _sessionStorage;

																																																																      Future<Response<T>> get<T>(
																																																																          String path, {
																																																																	      Map<String, dynamic>? queryParameters,
																																																																	        }) {
																																																																		    _ensureConfigured();
																																																																		        return _dio.get<T>(_relativePath(path), queryParameters: queryParameters);
																																																																			  }

																																																																			    Future<Response<T>> post<T>(String path, {Object? data}) {
																																																																			        _ensureConfigured();
																																																																				    return _dio.post<T>(_relativePath(path), data: data);
																																																																				      }

																																																																				        Future<Response<T>> patch<T>(String path, {Object? data}) {
																																																																					    _ensureConfigured();
																																																																					        return _dio.patch<T>(_relativePath(path), data: data);
																																																																						  }

																																																																						    Future<Response<T>> put<T>(String path, {Object? data}) {
																																																																						        _ensureConfigured();
																																																																							    return _dio.put<T>(_relativePath(path), data: data);
																																																																							      }

																																																																							        Future<Response<T>> delete<T>(String path) {
																																																																								    _ensureConfigured();
																																																																								        return _dio.delete<T>(_relativePath(path));
																																																																									  }

																																																																									    void _ensureConfigured() {
																																																																									        if (!AppConfig.isApiConfigured && _dio.options.baseUrl.isEmpty) {
																																																																										      throw const ApiConfigurationException();
																																																																										          }
																																																																											    }

																																																																											      String _relativePath(String path) => path.replaceFirst(RegExp(r'^/+'), '');

																																																																											        Future<String?> _refreshAccessToken() async {
																																																																												    final refreshToken = await _sessionStorage.readRefreshToken();
																																																																												        if (refreshToken == null || refreshToken.isEmpty) return null;
																																																																													    try {
																																																																													          final response = await _dio.post<Map<String, dynamic>>(
																																																																														          'auth/refresh',
																																																																															          data: {'refreshToken': refreshToken},
																																																																																        );
																																																																																	      final body = response.data;
																																																																																	            final accessToken = body?['accessToken'];
																																																																																		          if (accessToken is! String || accessToken.isEmpty) return null;
																																																																																			        final nextRefreshToken = body?['refreshToken'];
																																																																																				      await _sessionStorage.writeTokens(
																																																																																				              accessToken: accessToken,
																																																																																					              refreshToken: nextRefreshToken is String
																																																																																						                  ? nextRefreshToken
																																																																																								              : refreshToken,
																																																																																									            );
																																																																																										          return accessToken;
																																																																																											      } on DioException catch (error) {
																																																																																											            if (error.response?.statusCode == 401 ||
																																																																																												              error.response?.statusCode == 403) {
																																																																																													              await _sessionStorage.clear();
																																																																																														            }
																																																																																															          return null;
																																																																																																      } on FormatException {
																																																																																																            return null;
																																																																																																	        }
																																																																																																		  }
																																																																																																		  }

