import '../../../core/network/api_client.dart';

class VerificationRepository {
  const VerificationRepository(this._api);

    final ApiClient _api;

      Future<Map<String, dynamic>> getOnboardingStatus() async =>
            (await _api.get<Map<String, dynamic>>('onboarding/status')).data ??
	          <String, dynamic>{};

		    Future<void> sendCode({required String type}) async {
		        await _api.post<void>('auth/send-verification', data: {'type': type});
			  }

			    Future<void> verifyEmail({
			        required String email,
				    required String code,
				      }) async {
				          await _api.post<void>(
					        'auth/verify-email',
						      data: {'email': email.trim(), 'code': code.trim()},
						          );
							    }

							      Future<void> verifyPhone({
							          required String phone,
								      required String code,
								        }) async {
									    await _api.post<void>(
									          'auth/verify-phone',
										        data: {'phone': phone.trim(), 'code': code.trim()},
											    );
											      }
											      }

