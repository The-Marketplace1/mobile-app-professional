import '../../../core/network/api_client.dart';
import '../../../core/storage/session_store.dart';

class AuthRepository {
  const AuthRepository({
      required ApiClient apiClient,
          required SessionStore sessionStore,
	    }) : _apiClient = apiClient,
	           _sessionStore = sessionStore;

		     final ApiClient _apiClient;
		       final SessionStore _sessionStore;

		         Future<void> signIn({required String email, required String password}) async {
			     final response = await _apiClient.post<Map<String, dynamic>>(
			           'auth/signin',
				         data: {'email': email.trim(), 'password': password},
					     );
					         final body = response.data;
						     final accessToken = body?['accessToken'];
						         if (accessToken is! String || accessToken.isEmpty) {
							       throw const FormatException('The Gateway returned no access token.');
							           }

								       final refreshToken = body?['refreshToken'];
								           await _sessionStore.writeTokens(
									         accessToken: accessToken,
										       refreshToken: refreshToken is String ? refreshToken : null,
										           );
											     }

											       Future<bool> restoreSession() async {
											           final accessToken = await _sessionStore.readAccessToken();
												       if (accessToken == null || accessToken.isEmpty) return false;
												           await _apiClient.get<Map<String, dynamic>>('auth/me');
													       return true;
													         }

														   Future<void> signOut() async {
														       try {
														             await _apiClient.post<void>('auth/signout');
															         } finally {
																       await _sessionStore.clear();
																           }
																	     }

																	       Future<void> requestPasswordReset(String email) async {
																	           await _apiClient.post<void>(
																		         'auth/forgot-password',
																			       data: {'email': email.trim()},
																			           );
																				     }

																				       Future<void> sendVerificationCode(String type) async {
																				           await _apiClient.post<void>('auth/send-verification', data: {'type': type});
																					     }

																					       Future<void> verifyEmail(String email, String code) async {
																					           await _apiClient.post<void>(
																						         'auth/verify-email',
																							       data: {'email': email.trim(), 'code': code.trim()},
																							           );
																								     }

																								       Future<void> verifyPhone(String phone, String code) async {
																								           await _apiClient.post<void>(
																									         'auth/verify-phone',
																										       data: {'phone': phone.trim(), 'code': code.trim()},
																										           );
																											     }
																											     }

