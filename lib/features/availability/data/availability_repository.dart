import '../../../core/network/api_client.dart';

class AvailabilityRepository {
  const AvailabilityRepository(this._api);

    final ApiClient _api;

      Future<Map<String, dynamic>> getSchedule() async =>
            (await _api.get<Map<String, dynamic>>('availability/schedule')).data ??
	          <String, dynamic>{};

		    Future<Map<String, dynamic>> updateSchedule(
		        Map<String, dynamic> schedule,
			  ) async =>
			        (await _api.put<Map<String, dynamic>>(
				        'availability/schedule',
					        data: schedule,
						      )).data ??
						            <String, dynamic>{};

							      Future<List<dynamic>> getCalendar({
							          required String from,
								      required String to,
								        }) async =>
									      (await _api.get<List<dynamic>>(
									              'availability/calendar',
										              queryParameters: {'from': from, 'to': to},
											            )).data ??
												          const [];

													    Future<List<dynamic>> listHolidays() async =>
													          (await _api.get<List<dynamic>>('availability/holidays')).data ?? const [];

														    Future<Map<String, dynamic>> addHoliday(Map<String, dynamic> holiday) async =>
														          (await _api.post<Map<String, dynamic>>(
															          'availability/holidays',
																          data: holiday,
																	        )).data ??
																		      <String, dynamic>{};

																		        Future<void> deleteHoliday(String id) async {
																			    await _api.delete<void>('availability/holidays/$id');
																			      }
																			      }

