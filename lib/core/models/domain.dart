enum BookingStatus {
  pending,
    confirmed,
      assigned,
        accepted,
	  enRoute,
	    arriving,
	      arrived,
	        inProgress,
		  completed,
		    cancelled,
		    }

		    enum AppSection { today, bookings, jobs, messages, more }

		    class ProfessionalProfile {
		      const ProfessionalProfile({
		          required this.name,
			      required this.businessName,
			          required this.email,
				      required this.location,
				          required this.rating,
					      required this.reviewCount,
					          required this.verificationStatus,
						    });

						      final String name;
						        final String businessName;
							  final String email;
							    final String location;
							      final double? rating;
							        final int? reviewCount;
								  final String? verificationStatus;

								    ProfessionalProfile copyWith({
								        String? name,
									    String? businessName,
									        String? email,
										    String? location,
										        double? rating,
											    int? reviewCount,
											        String? verificationStatus,
												  }) => ProfessionalProfile(
												      name: name ?? this.name,
												          businessName: businessName ?? this.businessName,
													      email: email ?? this.email,
													          location: location ?? this.location,
														      rating: rating ?? this.rating,
														          reviewCount: reviewCount ?? this.reviewCount,
															      verificationStatus: verificationStatus ?? this.verificationStatus,
															        );
																}

																class ServiceItem {
																  const ServiceItem({
																      required this.id,
																          required this.title,
																	      required this.category,
																	          required this.description,
																		      required this.price,
																		          required this.durationMinutes,
																			      required this.active,
																			        });

																				  final String id;
																				    final String title;
																				      final String category;
																				        final String description;
																					  final int price;
																					    final int durationMinutes;
																					      final bool active;

																					        ServiceItem copyWith({bool? active}) => ServiceItem(
																						    id: id,
																						        title: title,
																							    category: category,
																							        description: description,
																								    price: price,
																								        durationMinutes: durationMinutes,
																									    active: active ?? this.active,
																									      );
																									      }

																									      class BookingItem {
																									        const BookingItem({
																										    required this.id,
																										        required this.customer,
																											    required this.service,
																											        required this.dateLabel,
																												    required this.timeLabel,
																												        required this.address,
																													    required this.amount,
																													        required this.status,
																														  });

																														    final String id;
																														      final String customer;
																														        final String service;
																															  final String dateLabel;
																															    final String timeLabel;
																															      final String address;
																															        final int? amount;
																																  final BookingStatus status;

																																    BookingItem copyWith({BookingStatus? status}) => BookingItem(
																																        id: id,
																																	    customer: customer,
																																	        service: service,
																																		    dateLabel: dateLabel,
																																		        timeLabel: timeLabel,
																																			    address: address,
																																			        amount: amount,
																																				    status: status ?? this.status,
																																				      );
																																				      }

																																				      class JobItem {
																																				        const JobItem({
																																					    required this.id,
																																					        required this.title,
																																						    required this.customer,
																																						        required this.status,
																																							    required this.dateLabel,
																																							        required this.location,
																																								  });

																																								    final String id;
																																								      final String title;
																																								        final String customer;
																																									  final String status;
																																									    final String dateLabel;
																																									      final String location;
																																									      }

																																									      class ConversationItem {
																																									        const ConversationItem({
																																										    required this.id,
																																										        required this.customer,
																																											    required this.preview,
																																											        required this.timeLabel,
																																												    required this.unread,
																																												        required this.online,
																																													  });

																																													    final String id;
																																													      final String customer;
																																													        final String preview;
																																														  final String timeLabel;
																																														    final int unread;
																																														      final bool online;
																																														      }

																																														      class ReviewItem {
																																														        const ReviewItem({
																																															    this.id = '',
																																															        required this.customer,
																																																    required this.comment,
																																																        required this.rating,
																																																	    required this.service,
																																																	        this.response,
																																																		  });

																																																		    final String id;
																																																		      final String customer;
																																																		        final String comment;
																																																			  final int rating;
																																																			    final String service;
																																																			      final String? response;
																																																			      }

																																																			      class NotificationItem {
																																																			        const NotificationItem({
																																																				    this.id = '',
																																																				        required this.title,
																																																					    required this.body,
																																																					        required this.timeLabel,
																																																						    required this.kind,
																																																						        this.read = false,
																																																							  });

																																																							    final String id;
																																																							      final String title;
																																																							        final String body;
																																																								  final String timeLabel;
																																																								    final String kind;
																																																								      final bool read;

																																																								        NotificationItem copyWith({bool? read}) => NotificationItem(
																																																									    id: id,
																																																									        title: title,
																																																										    body: body,
																																																										        timeLabel: timeLabel,
																																																											    kind: kind,
																																																											        read: read ?? this.read,
																																																												  );
																																																												  }

