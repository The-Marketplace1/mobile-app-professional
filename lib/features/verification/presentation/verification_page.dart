import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/section_card.dart';

class VerificationPage extends ConsumerStatefulWidget {
  const VerificationPage({super.key});

    @override
      ConsumerState<VerificationPage> createState() => _VerificationPageState();
      }

      class _VerificationPageState extends ConsumerState<VerificationPage> {
        final email = TextEditingController();
	  final phone = TextEditingController();
	    final code = TextEditingController();
	      bool usePhone = false;
	        bool loading = false;
		  String? message;
		    String? error;

		      @override
		        void dispose() {
			    email.dispose();
			        phone.dispose();
				    code.dispose();
				        super.dispose();
					  }

					    Future<void> _sendCode() async {
					        setState(() {
						      loading = true;
						            error = null;
							          message = null;
								      });
								          try {
									        await ref
										          .read(verificationRepositoryProvider)
											            .sendCode(type: usePhone ? 'phone' : 'email');
												          if (!mounted) return;
													        setState(() {
														        message = 'A verification code was requested.';
															      });
															          } catch (exception) {
																        if (!mounted) return;
																	      setState(() {
																	              error = exception is ApiConfigurationException
																		                  ? 'Configure the API Gateway to request a verification code.'
																				              : 'The code could not be sent. Check the contact details and retry.';
																					            });
																						        } finally {
																							      if (mounted) setState(() => loading = false);
																							          }
																								    }

																								      Future<void> _verify() async {
																								          if (code.text.trim().isEmpty ||
																									          (usePhone ? phone.text.trim() : email.text.trim()).isEmpty) {
																										        setState(
																											        () => error = 'Enter your contact details and verification code.',
																												      );
																												            return;
																													        }
																														    setState(() {
																														          loading = true;
																															        error = null;
																																      message = null;
																																          });
																																	      try {
																																	            final repository = ref.read(verificationRepositoryProvider);
																																		          if (usePhone) {
																																			          await repository.verifyPhone(phone: phone.text, code: code.text);
																																				        } else {
																																					        await repository.verifyEmail(email: email.text, code: code.text);
																																						      }
																																						            if (!mounted) return;
																																							          setState(() => message = 'Contact verified successfully.');
																																								      } catch (exception) {
																																								            if (!mounted) return;
																																									          setState(() {
																																										          error = exception is ApiConfigurationException
																																											              ? 'Configure the API Gateway before verifying your account.'
																																												                  : 'Verification failed. Check the code and try again.';
																																														        });
																																															    } finally {
																																															          if (mounted) setState(() => loading = false);
																																																      }
																																																        }

																																																	  @override
																																																	    Widget build(BuildContext context) => Scaffold(
																																																	        appBar: AppBar(title: const Text('Verification')),
																																																		    body: ListView(
																																																		          padding: const EdgeInsets.all(20),
																																																			        children: [
																																																				        const Text(
																																																					          'Confirm your contact details',
																																																						            style: TextStyle(
																																																							                color: AppTheme.ink,
																																																									            fontSize: 26,
																																																										                fontWeight: FontWeight.w800,
																																																												          ),
																																																													          ),
																																																														          const SizedBox(height: 8),
																																																															          const Text(
																																																																            'Verification requests are sent through the API Gateway. '
																																																																	              'Documents cannot be uploaded until an upload route is available.',
																																																																		                style: TextStyle(color: AppTheme.muted, height: 1.4),
																																																																				        ),
																																																																					        const SizedBox(height: 18),
																																																																						        SectionCard(
																																																																							          title: 'Choose a contact method',
																																																																								            child: Column(
																																																																									                children: [
																																																																											              SegmentedButton<bool>(
																																																																												                      segments: const [
																																																																														                        ButtonSegment(value: false, label: Text('Email')),
																																																																																	                  ButtonSegment(value: true, label: Text('Phone')),
																																																																																			                  ],
																																																																																					                  selected: {usePhone},
																																																																																							                  onSelectionChanged: loading
																																																																																									                      ? null
																																																																																											                          : (selection) => setState(() => usePhone = selection.first),
																																																																																														                ),
																																																																																																              const SizedBox(height: 14),
																																																																																																	                    if (usePhone)
																																																																																																			                    TextField(
																																																																																																					                      controller: phone,
																																																																																																							                        keyboardType: TextInputType.phone,
																																																																																																										                  decoration: const InputDecoration(
																																																																																																												                      labelText: 'Phone number',
																																																																																																														                          prefixIcon: Icon(Icons.phone_outlined),
																																																																																																																	                    ),
																																																																																																																			                    )
																																																																																																																					                  else
																																																																																																																							                  TextField(
																																																																																																																									                    controller: email,
																																																																																																																											                      keyboardType: TextInputType.emailAddress,
																																																																																																																													                        decoration: const InputDecoration(
																																																																																																																																                    labelText: 'Email address',
																																																																																																																																		                        prefixIcon: Icon(Icons.email_outlined),
																																																																																																																																					                  ),
																																																																																																																																							                  ),
																																																																																																																																									                const SizedBox(height: 12),
																																																																																																																																											              TextField(
																																																																																																																																												                      controller: code,
																																																																																																																																														                      keyboardType: TextInputType.number,
																																																																																																																																																                      decoration: const InputDecoration(
																																																																																																																																																		                        labelText: 'Verification code',
																																																																																																																																																					                  prefixIcon: Icon(Icons.pin_outlined),
																																																																																																																																																							                  ),
																																																																																																																																																									                ),
																																																																																																																																																											              const SizedBox(height: 12),
																																																																																																																																																												                    if (error != null)
																																																																																																																																																														                    Align(
																																																																																																																																																																                      alignment: Alignment.centerLeft,
																																																																																																																																																																		                        child: Text(
																																																																																																																																																																					                    error!,
																																																																																																																																																																							                        style: const TextStyle(color: AppTheme.coral),
																																																																																																																																																																										                  ),
																																																																																																																																																																												                  ),
																																																																																																																																																																														                if (message != null)
																																																																																																																																																																																                Align(
																																																																																																																																																																																		                  alignment: Alignment.centerLeft,
																																																																																																																																																																																				                    child: Text(
																																																																																																																																																																																						                        message!,
																																																																																																																																																																																									                    style: const TextStyle(color: AppTheme.teal),
																																																																																																																																																																																											                      ),
																																																																																																																																																																																													                      ),
																																																																																																																																																																																															                    const SizedBox(height: 12),
																																																																																																																																																																																																	                  Row(
																																																																																																																																																																																																			                  children: [
																																																																																																																																																																																																					                    Expanded(
																																																																																																																																																																																																							                        child: OutlinedButton(
																																																																																																																																																																																																										                      onPressed: loading ? null : _sendCode,
																																																																																																																																																																																																												                            child: const Text('Send code'),
																																																																																																																																																																																																															                        ),
																																																																																																																																																																																																																		                  ),
																																																																																																																																																																																																																				                    const SizedBox(width: 10),
																																																																																																																																																																																																																						                      Expanded(
																																																																																																																																																																																																																								                          child: FilledButton(
																																																																																																																																																																																																																											                        onPressed: loading ? null : _verify,
																																																																																																																																																																																																																														                      child: Text(loading ? 'Please wait…' : 'Verify'),
																																																																																																																																																																																																																																                          ),
																																																																																																																																																																																																																																			                    ),
																																																																																																																																																																																																																																					                    ],
																																																																																																																																																																																																																																							                  ),
																																																																																																																																																																																																																																									              ],
																																																																																																																																																																																																																																										                ),
																																																																																																																																																																																																																																												        ),
																																																																																																																																																																																																																																													      ],
																																																																																																																																																																																																																																													          ),
																																																																																																																																																																																																																																														    );
																																																																																																																																																																																																																																														    }

