import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../shared/widgets/section_card.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

    @override
      State<OnboardingPage> createState() => _OnboardingPageState();
      }

      class _OnboardingPageState extends State<OnboardingPage> {
        int step = 0;
	  final selectedWorkingDays = <int>{0, 1, 2, 3, 4};
	    final dayNames = const [
	        'Monday',
		    'Tuesday',
		        'Wednesday',
			    'Thursday',
			        'Friday',
				    'Saturday',
				        'Sunday',
					  ];
					    final steps = const [
					        (
						      'Your professional profile',
						            'Tell customers what you do and where you work.',
							        ),
								    (
								          'Verification documents',
									        'Upload the permitted documents requested by the team.',
										    ),
										        (
											      'Set your availability',
											            'Choose when customers can request your services.',
												        ),
													  ];

													    @override
													      Widget build(BuildContext context) {
													          final current = steps[step];
														      return Scaffold(
														            appBar: AppBar(
															            leading: IconButton(
																              onPressed: () => context.go('/auth'),
																	                icon: const Icon(Icons.close),
																			        ),
																				        title: const AppMark(compact: true),
																					      ),
																					            body: ListView(
																						            padding: const EdgeInsets.all(24),
																							            children: [
																								              Text(
																									                  'STEP ${step + 1} OF ${steps.length}',
																											              style: const TextStyle(
																												                    color: AppTheme.muted,
																														                  letterSpacing: 1.6,
																																                fontSize: 11,
																																		              fontWeight: FontWeight.w800,
																																			                  ),
																																					            ),
																																						              const SizedBox(height: 12),
																																							                Text(
																																									            current.$1,
																																										                style: const TextStyle(
																																												              color: AppTheme.ink,
																																													                    fontSize: 30,
																																															                  fontWeight: FontWeight.w800,
																																																	              ),
																																																		                ),
																																																				          const SizedBox(height: 8),
																																																					            Text(current.$2, style: const TextStyle(color: AppTheme.muted)),
																																																						              const SizedBox(height: 24),
																																																							                LinearProgressIndicator(
																																																									            value: (step + 1) / steps.length,
																																																										                color: AppTheme.ochre,
																																																												            backgroundColor: AppTheme.navy.withAlpha(20),
																																																													                minHeight: 7,
																																																															            borderRadius: BorderRadius.circular(8),
																																																																              ),
																																																																	                const SizedBox(height: 24),
																																																																			          SectionCard(
																																																																				              title: step == 0
																																																																					                      ? 'Basic information'
																																																																							                      : step == 1
																																																																									                      ? 'Verification checklist'
																																																																											                      : 'Working hours',
																																																																													                  child: step == 0
																																																																															                  ? const Column(
																																																																																	                      children: [
																																																																																			                            TextField(
																																																																																						                            decoration: InputDecoration(
																																																																																									                              labelText: 'Full name',
																																																																																												                                prefixIcon: Icon(Icons.person_outline),
																																																																																																                        ),
																																																																																																			                      ),
																																																																																																					                            SizedBox(height: 13),
																																																																																																								                          TextField(
																																																																																																											                          decoration: InputDecoration(
																																																																																																														                            labelText: 'Business name',
																																																																																																																	                              prefixIcon: Icon(Icons.storefront_outlined),
																																																																																																																				                              ),
																																																																																																																							                            ),
																																																																																																																										                          SizedBox(height: 13),
																																																																																																																													                        TextField(
																																																																																																																																                        decoration: InputDecoration(
																																																																																																																																			                          labelText: 'Service area',
																																																																																																																																						                            prefixIcon: Icon(Icons.location_on_outlined),
																																																																																																																																									                            ),
																																																																																																																																												                          ),
																																																																																																																																															                      ],
																																																																																																																																																	                        )
																																																																																																																																																				                : step == 1
																																																																																																																																																						                ? Column(
																																																																																																																																																								                    children: [
																																																																																																																																																										                          _UploadRow(
																																																																																																																																																													                          title: 'Government ID',
																																																																																																																																																																                          subtitle: 'PDF, JPG or PNG · up to 10 MB',
																																																																																																																																																																			                        ),
																																																																																																																																																																						                      _UploadRow(
																																																																																																																																																																								                              title: 'Professional qualification',
																																																																																																																																																																											                              subtitle: 'Optional · PDF or image',
																																																																																																																																																																														                            ),
																																																																																																																																																																																	                          _UploadRow(
																																																																																																																																																																																				                          title: 'Proof of address',
																																																																																																																																																																																							                          subtitle: 'PDF, JPG or PNG · up to 10 MB',
																																																																																																																																																																																										                        ),
																																																																																																																																																																																													                    ],
																																																																																																																																																																																															                      )
																																																																																																																																																																																																	                      : Column(
																																																																																																																																																																																																			                          children: [
																																																																																																																																																																																																						                        for (var index = 0; index < dayNames.length; index++)
																																																																																																																																																																																																									                        SwitchListTile(
																																																																																																																																																																																																												                          value: selectedWorkingDays.contains(index),
																																																																																																																																																																																																															                            onChanged: (enabled) => setState(() {
																																																																																																																																																																																																																		                                if (enabled) {
																																																																																																																																																																																																																						                              selectedWorkingDays.add(index);
																																																																																																																																																																																																																									                                  } else {
																																																																																																																																																																																																																													                                selectedWorkingDays.remove(index);
																																																																																																																																																																																																																																	                            }
																																																																																																																																																																																																																																				                              }),
																																																																																																																																																																																																																																							                                title: Text(dayNames[index]),
																																																																																																																																																																																																																																											                          subtitle: Text(
																																																																																																																																																																																																																																														                              selectedWorkingDays.contains(index)
																																																																																																																																																																																																																																																	                                      ? '9:00 AM – 5:00 PM'
																																																																																																																																																																																																																																																					                                      : 'Not working',
																																																																																																																																																																																																																																																									                                ),
																																																																																																																																																																																																																																																													                          contentPadding: EdgeInsets.zero,
																																																																																																																																																																																																																																																																                          ),
																																																																																																																																																																																																																																																																			                      ],
																																																																																																																																																																																																																																																																					                        ),
																																																																																																																																																																																																																																																																								          ),
																																																																																																																																																																																																																																																																									            const SizedBox(height: 24),
																																																																																																																																																																																																																																																																										              FilledButton(
																																																																																																																																																																																																																																																																											                  onPressed: () {
																																																																																																																																																																																																																																																																													                if (step < steps.length - 1) {
																																																																																																																																																																																																																																																																															                setState(() => step++);
																																																																																																																																																																																																																																																																																	              } else {
																																																																																																																																																																																																																																																																																		                      showDialog<void>(
																																																																																																																																																																																																																																																																																				                        context: context,
																																																																																																																																																																																																																																																																																							                  builder: (dialogContext) => AlertDialog(
																																																																																																																																																																																																																																																																																									                      title: const Text('Onboarding is not submitted'),
																																																																																																																																																																																																																																																																																											                          content: const Text(
																																																																																																																																																																																																																																																																																														                        'The current API contract does not include account '
																																																																																																																																																																																																																																																																																																	                      'registration or document upload. Your information has '
																																																																																																																																																																																																																																																																																																			                            'not been sent or saved.',
																																																																																																																																																																																																																																																																																																						                        ),
																																																																																																																																																																																																																																																																																																									                    actions: [
																																																																																																																																																																																																																																																																																																											                          TextButton(
																																																																																																																																																																																																																																																																																																														                          onPressed: () => Navigator.pop(dialogContext),
																																																																																																																																																																																																																																																																																																																	                          child: const Text('Close'),
																																																																																																																																																																																																																																																																																																																				                        ),
																																																																																																																																																																																																																																																																																																																							                      FilledButton(
																																																																																																																																																																																																																																																																																																																									                              onPressed: () {
																																																																																																																																																																																																																																																																																																																												                                Navigator.pop(dialogContext);
																																																																																																																																																																																																																																																																																																																																                          context.go('/auth');
																																																																																																																																																																																																																																																																																																																																			                          },
																																																																																																																																																																																																																																																																																																																																						                          child: const Text('Go to sign in'),
																																																																																																																																																																																																																																																																																																																																									                        ),
																																																																																																																																																																																																																																																																																																																																												                    ],
																																																																																																																																																																																																																																																																																																																																														                      ),
																																																																																																																																																																																																																																																																																																																																																                      );
																																																																																																																																																																																																																																																																																																																																																		                    }
																																																																																																																																																																																																																																																																																																																																																				                },
																																																																																																																																																																																																																																																																																																																																																						            style: FilledButton.styleFrom(
																																																																																																																																																																																																																																																																																																																																																							                  backgroundColor: AppTheme.navy,
																																																																																																																																																																																																																																																																																																																																																									                padding: const EdgeInsets.symmetric(vertical: 15),
																																																																																																																																																																																																																																																																																																																																																											            ),
																																																																																																																																																																																																																																																																																																																																																												                child: Text(
																																																																																																																																																																																																																																																																																																																																																														              step == steps.length - 1 ? 'Submit for review' : 'Continue',
																																																																																																																																																																																																																																																																																																																																																															                  ),
																																																																																																																																																																																																																																																																																																																																																																	            ),
																																																																																																																																																																																																																																																																																																																																																																		            ],
																																																																																																																																																																																																																																																																																																																																																																			          ),
																																																																																																																																																																																																																																																																																																																																																																				      );
																																																																																																																																																																																																																																																																																																																																																																				        }
																																																																																																																																																																																																																																																																																																																																																																					}

																																																																																																																																																																																																																																																																																																																																																																					class _UploadRow extends StatelessWidget {
																																																																																																																																																																																																																																																																																																																																																																					  const _UploadRow({required this.title, required this.subtitle});

																																																																																																																																																																																																																																																																																																																																																																					    final String title;
																																																																																																																																																																																																																																																																																																																																																																					      final String subtitle;

																																																																																																																																																																																																																																																																																																																																																																					        @override
																																																																																																																																																																																																																																																																																																																																																																						  Widget build(BuildContext context) => ListTile(
																																																																																																																																																																																																																																																																																																																																																																						      contentPadding: EdgeInsets.zero,
																																																																																																																																																																																																																																																																																																																																																																						          leading: const Icon(Icons.upload_file_outlined, color: AppTheme.teal),
																																																																																																																																																																																																																																																																																																																																																																							      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
																																																																																																																																																																																																																																																																																																																																																																							          subtitle: Text(subtitle),
																																																																																																																																																																																																																																																																																																																																																																								      trailing: OutlinedButton(
																																																																																																																																																																																																																																																																																																																																																																								            onPressed: () {
																																																																																																																																																																																																																																																																																																																																																																									            ScaffoldMessenger.of(context).showSnackBar(
																																																																																																																																																																																																																																																																																																																																																																										              const SnackBar(
																																																																																																																																																																																																																																																																																																																																																																											                  content: Text(
																																																																																																																																																																																																																																																																																																																																																																													                'Document upload is not available in the current API contract. '
																																																																																																																																																																																																																																																																																																																																																																															              'No file was selected or sent.',
																																																																																																																																																																																																																																																																																																																																																																																                  ),
																																																																																																																																																																																																																																																																																																																																																																																		            ),
																																																																																																																																																																																																																																																																																																																																																																																			            );
																																																																																																																																																																																																																																																																																																																																																																																				          },
																																																																																																																																																																																																																																																																																																																																																																																					        child: const Text('Unavailable'),
																																																																																																																																																																																																																																																																																																																																																																																						    ),
																																																																																																																																																																																																																																																																																																																																																																																						      );
																																																																																																																																																																																																																																																																																																																																																																																						      }

