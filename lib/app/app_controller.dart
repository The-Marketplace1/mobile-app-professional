import 'package:flutter/foundation.dart';

import '../core/models/domain.dart';
import '../core/network/api_client.dart';
import '../features/dashboard/data/workspace_repository.dart';
import '../features/auth/data/auth_repository.dart';

class AppController extends ChangeNotifier {
  AppController({WorkspaceRepository? workspaceRepository})
      : _workspaceRepository = workspaceRepository;

        final WorkspaceRepository? _workspaceRepository;
	  bool authenticated = false;
	    bool onboardingComplete = false;
	      bool workspaceLoading = false;
	        bool workspaceLoaded = false;
		  String? workspaceLoadError;
		    AppSection section = AppSection.today;
		      int availableToWithdraw = 0;
		        int pendingBalance = 0;
			  int totalEarned = 0;
			    int? thisMonthEarned;
			      int? lastMonthEarned;
			        String? currencyCode;
				  double completionRate = 0;

				    ProfessionalProfile profile = const ProfessionalProfile(
				        name: '',
					    businessName: '',
					        email: '',
						    location: '',
						        rating: null,
							    reviewCount: null,
							        verificationStatus: null,
								  );

								    final services = <ServiceItem>[];
								      final bookings = <BookingItem>[];
								        final jobs = <JobItem>[];
									  final conversations = <ConversationItem>[];
									    final notifications = <NotificationItem>[];
									      final reviews = <ReviewItem>[];
									        final recentActivity = <WorkspaceActivity>[];

										  void setAuthenticated(bool value) {
										      authenticated = value;
										          if (!value) {
											        workspaceLoadError = null;
												      workspaceLoaded = false;
												            _clearWorkspace();
													        }
														    notifyListeners();
														      }

														        Future<void> loadWorkspace() async {
															    final repository = _workspaceRepository;
															        workspaceLoadError = null;
																    if (repository == null) {
																          _clearWorkspace();
																	        workspaceLoaded = false;
																		      workspaceLoadError =
																		                'API Gateway is not configured. No workspace data was loaded.';
																				      notifyListeners();
																				            return;
																					        }
																						    workspaceLoading = true;
																						        notifyListeners();
																							    try {
																							          final data = await repository.load();
																								        profile = data.profile;
																									      services
																									              ..clear()
																										              ..addAll(data.services);
																											            bookings
																												            ..clear()
																													            ..addAll(data.bookings);
																														          jobs
																															          ..clear()
																																          ..addAll(data.jobs);
																																	        conversations
																																		        ..clear()
																																			        ..addAll(data.conversations);
																																				      notifications
																																				              ..clear()
																																					              ..addAll(data.notifications);
																																						            reviews
																																							            ..clear()
																																								            ..addAll(data.reviews);
																																									          recentActivity
																																										          ..clear()
																																											          ..addAll(data.recentActivity);
																																												        availableToWithdraw = data.availableBalance;
																																													      pendingBalance = data.pendingBalance;
																																													            totalEarned = data.totalEarned;
																																														          thisMonthEarned = data.thisMonth;
																																															        lastMonthEarned = data.lastMonth;
																																																      currencyCode = data.currency;
																																																            completionRate = data.completionRate;
																																																	          workspaceLoaded = true;
																																																		      } catch (error) {
																																																		            workspaceLoadError = error is ApiConfigurationException
																																																			              ? 'API Gateway is not configured. No live workspace data is available.'
																																																				                : 'Workspace data could not be loaded. No changes were applied.';
																																																						      _clearWorkspace();
																																																						            workspaceLoaded = false;
																																																							        } finally {
																																																								      workspaceLoading = false;
																																																								            notifyListeners();
																																																									        }
																																																										  }

																																																										    void _clearWorkspace() {
																																																										        profile = const ProfessionalProfile(
																																																											      name: '',
																																																											            businessName: '',
																																																												          email: '',
																																																													        location: '',
																																																														      rating: null,
																																																														            reviewCount: null,
																																																															          verificationStatus: null,
																																																																      );
																																																																          services.clear();
																																																																	      bookings.clear();
																																																																	          jobs.clear();
																																																																		      conversations.clear();
																																																																		          notifications.clear();
																																																																			      reviews.clear();
																																																																			          recentActivity.clear();
																																																																				      availableToWithdraw = 0;
																																																																				          pendingBalance = 0;
																																																																					      totalEarned = 0;
																																																																					          thisMonthEarned = null;
																																																																						      lastMonthEarned = null;
																																																																						          completionRate = 0;
																																																																							      currencyCode = null;
																																																																							        }

																																																																								  Future<void> restoreSession(AuthRepository authRepository) async {
																																																																								      try {
																																																																								            authenticated = await authRepository.restoreSession();
																																																																									          if (authenticated) await loadWorkspace();
																																																																										        else _clearWorkspace();
																																																																											    } catch (_) {
																																																																											          authenticated = false;
																																																																												        workspaceLoaded = false;
																																																																													      _clearWorkspace();
																																																																													          }
																																																																														      notifyListeners();
																																																																														        }

																																																																															  void signOut() {
																																																																															      authenticated = false;
																																																																															          workspaceLoadError = null;
																																																																																      workspaceLoaded = false;
																																																																																          workspaceLoading = false;
																																																																																	      _clearWorkspace();
																																																																																	          notifyListeners();
																																																																																		    }

																																																																																		      void finishOnboarding() {
																																																																																		          onboardingComplete = true;
																																																																																			      notifyListeners();
																																																																																			        }

																																																																																				  void select(AppSection value) {
																																																																																				      section = value;
																																																																																				          notifyListeners();
																																																																																					    }

																																																																																					      void updateProfile(ProfessionalProfile value) {
																																																																																					          profile = value;
																																																																																						      notifyListeners();
																																																																																						        }

																																																																																							  void acceptBooking(String id) {
																																																																																							      final index = bookings.indexWhere((booking) => booking.id == id);
																																																																																							          if (index < 0) return;
																																																																																								      bookings[index] = bookings[index].copyWith(status: BookingStatus.accepted);
																																																																																								          notifyListeners();
																																																																																									    }

																																																																																									      void declineBooking(String id) {
																																																																																									          final index = bookings.indexWhere((booking) => booking.id == id);
																																																																																										      if (index < 0) return;
																																																																																										          bookings[index] = bookings[index].copyWith(status: BookingStatus.cancelled);
																																																																																											      notifyListeners();
																																																																																											        }

																																																																																												  void addService(ServiceItem service) {
																																																																																												      services.add(service);
																																																																																												          notifyListeners();
																																																																																													    }

																																																																																													      void updateReviewResponse(String id, String response) {
																																																																																													          final index = reviews.indexWhere((review) => review.id == id);
																																																																																														      if (index < 0) return;
																																																																																														          final review = reviews[index];
																																																																																															      reviews[index] = ReviewItem(
																																																																																															            id: review.id,
																																																																																																          customer: review.customer,
																																																																																																	        comment: review.comment,
																																																																																																		      rating: review.rating,
																																																																																																		            service: review.service,
																																																																																																			          response: response,
																																																																																																				      );
																																																																																																				          notifyListeners();
																																																																																																					    }

																																																																																																					      void toggleService(String id) {
																																																																																																					          final index = services.indexWhere((service) => service.id == id);
																																																																																																						      if (index < 0) return;
																																																																																																						          services[index] = services[index].copyWith(active: !services[index].active);
																																																																																																							      notifyListeners();
																																																																																																							        }

																																																																																																								  void completeJob(String id) {
																																																																																																								      final index = jobs.indexWhere((job) => job.id == id);
																																																																																																								          if (index < 0) return;
																																																																																																									      final job = jobs[index];
																																																																																																									          jobs[index] = JobItem(
																																																																																																										        id: job.id,
																																																																																																											      title: job.title,
																																																																																																											            customer: job.customer,
																																																																																																												          status: 'Completed',
																																																																																																													        dateLabel: job.dateLabel,
																																																																																																														      location: job.location,
																																																																																																														          );
																																																																																																															      notifyListeners();
																																																																																																															        }

																																																																																																																  void markNotificationsRead() {
																																																																																																																      for (var i = 0; i < notifications.length; i++) {
																																																																																																																            notifications[i] = notifications[i].copyWith(read: true);
																																																																																																																	        }
																																																																																																																		    notifyListeners();
																																																																																																																		      }

																																																																																																																		      }

