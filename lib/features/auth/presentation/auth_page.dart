import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../shared/widgets/section_card.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

    @override
      ConsumerState<AuthPage> createState() => _AuthPageState();
      }

      class _AuthPageState extends ConsumerState<AuthPage> {
        final formKey = GlobalKey<FormState>();
	  final email = TextEditingController();
	    final password = TextEditingController();
	      bool loading = false;
	        bool obscure = true;
		  String? errorMessage;

		    @override
		      void dispose() {
		          email.dispose();
			      password.dispose();
			          super.dispose();
				    }

				      Future<void> signIn() async {
				          if (!formKey.currentState!.validate()) return;
					      setState(() {
					            loading = true;
						          errorMessage = null;
							      });
							          try {
								        await ref
									          .read(authRepositoryProvider)
										            .signIn(email: email.text, password: password.text);
											          if (!mounted) return;
												        final controller = ref.read(appControllerProvider);
													      controller.setAuthenticated(true);
													            await controller.loadWorkspace();
														          if (!mounted) return;
															        context.go('/');
																    } catch (error) {
																          if (!mounted) return;
																	        setState(() {
																		        errorMessage = error is ApiConfigurationException
																			            ? 'Sign-in is unavailable until the API Gateway is configured.'
																				                : 'Sign-in failed. Check your details and connection, then try again.';
																						      });
																						          } finally {
																							        if (mounted) setState(() => loading = false);
																								    }
																								      }

																								        Future<void> requestPasswordReset() async {
																									    final resetEmail = TextEditingController(text: email.text.trim());
																									        final submittedEmail = await showDialog<String>(
																										      context: context,
																										            builder: (dialogContext) => AlertDialog(
																											            title: const Text('Reset your password'),
																												            content: TextField(
																													              controller: resetEmail,
																														                autofocus: true,
																																          keyboardType: TextInputType.emailAddress,
																																	            decoration: const InputDecoration(labelText: 'Email address'),
																																		            ),
																																			            actions: [
																																				              TextButton(
																																					                  onPressed: () => Navigator.pop(dialogContext),
																																							              child: const Text('Cancel'),
																																								                ),
																																										          FilledButton(
																																											              onPressed: () => Navigator.pop(dialogContext, resetEmail.text),
																																												                  child: const Text('Send link'),
																																														            ),
																																															            ],
																																																          ),
																																																	      );
																																																	          resetEmail.dispose();
																																																		      if (submittedEmail == null || submittedEmail.trim().isEmpty || !mounted) {
																																																		            return;
																																																			        }
																																																				    try {
																																																				          await ref
																																																					            .read(authRepositoryProvider)
																																																						              .requestPasswordReset(submittedEmail);
																																																							            if (!mounted) return;
																																																								          ScaffoldMessenger.of(context).showSnackBar(
																																																									          const SnackBar(
																																																										            content: Text('If the account exists, a reset email was sent.'),
																																																											            ),
																																																												          );
																																																													      } catch (error) {
																																																													            if (!mounted) return;
																																																														          final message = error is ApiConfigurationException
																																																															            ? 'Password reset is unavailable until the API Gateway is configured.'
																																																																              : 'Could not request a reset link. Please try again later.';
																																																																	            ScaffoldMessenger.of(
																																																																		            context,
																																																																			          ).showSnackBar(SnackBar(content: Text(message)));
																																																																				      }
																																																																				        }

																																																																					  @override
																																																																					    Widget build(BuildContext context) => Scaffold(
																																																																					        body: SafeArea(
																																																																						      child: Center(
																																																																						              child: SingleChildScrollView(
																																																																							                padding: const EdgeInsets.all(24),
																																																																									          child: ConstrainedBox(
																																																																										              constraints: const BoxConstraints(maxWidth: 440),
																																																																											                  child: Column(
																																																																													                crossAxisAlignment: CrossAxisAlignment.stretch,
																																																																															              children: [
																																																																																                      const AppMark(),
																																																																																		                      const SizedBox(height: 44),
																																																																																				                      const Text(
																																																																																						                        'Welcome back.',
																																																																																									                  style: TextStyle(
																																																																																											                      fontSize: 34,
																																																																																													                          fontWeight: FontWeight.w800,
																																																																																																                      color: AppTheme.ink,
																																																																																																		                        ),
																																																																																																					                ),
																																																																																																							                const SizedBox(height: 8),
																																																																																																									                const Text(
																																																																																																											                  'Sign in to keep your professional workspace moving.',
																																																																																																													                    style: TextStyle(color: AppTheme.muted, height: 1.45),
																																																																																																															                    ),
																																																																																																																	                    const SizedBox(height: 26),
																																																																																																																			                    SectionCard(
																																																																																																																					                      title: 'Professional sign in',
																																																																																																																							                        child: Form(
																																																																																																																										                    key: formKey,
																																																																																																																												                        child: Column(
																																																																																																																															                      crossAxisAlignment: CrossAxisAlignment.stretch,
																																																																																																																																	                            children: [
																																																																																																																																				                            TextFormField(
																																																																																																																																							                              controller: email,
																																																																																																																																										                                keyboardType: TextInputType.emailAddress,
																																																																																																																																														                          textInputAction: TextInputAction.next,
																																																																																																																																																	                            validator: (value) {
																																																																																																																																																				                                final candidate = value?.trim() ?? '';
																																																																																																																																																								                            if (!candidate.contains('@') ||
																																																																																																																																																											                                    candidate.endsWith('@')) {
																																																																																																																																																															                                  return 'Enter a valid email address';
																																																																																																																																																																			                              }
																																																																																																																																																																						                                  return null;
																																																																																																																																																																										                            },
																																																																																																																																																																													                              decoration: const InputDecoration(
																																																																																																																																																																																                                  labelText: 'Email address',
																																																																																																																																																																																				                              prefixIcon: Icon(Icons.email_outlined),
																																																																																																																																																																																							                                ),
																																																																																																																																																																																											                        ),
																																																																																																																																																																																														                        const SizedBox(height: 13),
																																																																																																																																																																																																	                        TextFormField(
																																																																																																																																																																																																				                          controller: password,
																																																																																																																																																																																																							                            obscureText: obscure,
																																																																																																																																																																																																										                              textInputAction: TextInputAction.done,
																																																																																																																																																																																																													                                validator: (value) => (value ?? '').isEmpty
																																																																																																																																																																																																																	                              ? 'Enter your password'
																																																																																																																																																																																																																				                                    : null,
																																																																																																																																																																																																																								                              onFieldSubmitted: (_) => signIn(),
																																																																																																																																																																																																																											                                decoration: InputDecoration(
																																																																																																																																																																																																																															                            labelText: 'Password',
																																																																																																																																																																																																																																		                                prefixIcon: const Icon(Icons.lock_outline),
																																																																																																																																																																																																																																						                            suffixIcon: IconButton(
																																																																																																																																																																																																																																									                                  onPressed: () =>
																																																																																																																																																																																																																																													                                    setState(() => obscure = !obscure),
																																																																																																																																																																																																																																																	                                  icon: Icon(
																																																																																																																																																																																																																																																					                                  obscure
																																																																																																																																																																																																																																																									                                      ? Icons.visibility_outlined
																																																																																																																																																																																																																																																													                                          : Icons.visibility_off_outlined,
																																																																																																																																																																																																																																																																		                                ),
																																																																																																																																																																																																																																																																						                            ),
																																																																																																																																																																																																																																																																									                              ),
																																																																																																																																																																																																																																																																												                              ),
																																																																																																																																																																																																																																																																															                              Align(
																																																																																																																																																																																																																																																																																		                                alignment: Alignment.centerRight,
																																																																																																																																																																																																																																																																																						                          child: TextButton(
																																																																																																																																																																																																																																																																																									                              onPressed: loading ? null : requestPasswordReset,
																																																																																																																																																																																																																																																																																												                                  child: const Text('Forgot password?'),
																																																																																																																																																																																																																																																																																																                            ),
																																																																																																																																																																																																																																																																																																			                            ),
																																																																																																																																																																																																																																																																																																						                            if (errorMessage != null) ...[
																																																																																																																																																																																																																																																																																																									                              const SizedBox(height: 4),
																																																																																																																																																																																																																																																																																																												                                Text(
																																																																																																																																																																																																																																																																																																																                            errorMessage!,
																																																																																																																																																																																																																																																																																																																			                                style: const TextStyle(color: AppTheme.coral),
																																																																																																																																																																																																																																																																																																																							                          ),
																																																																																																																																																																																																																																																																																																																										                            const SizedBox(height: 12),
																																																																																																																																																																																																																																																																																																																													                            ],
																																																																																																																																																																																																																																																																																																																																                            FilledButton(
																																																																																																																																																																																																																																																																																																																																			                              onPressed: loading ? null : signIn,
																																																																																																																																																																																																																																																																																																																																						                                style: FilledButton.styleFrom(
																																																																																																																																																																																																																																																																																																																																										                            backgroundColor: AppTheme.navy,
																																																																																																																																																																																																																																																																																																																																													                                padding: const EdgeInsets.symmetric(vertical: 15),
																																																																																																																																																																																																																																																																																																																																																	                          ),
																																																																																																																																																																																																																																																																																																																																																				                            child: loading
																																																																																																																																																																																																																																																																																																																																																							                                  ? const SizedBox(
																																																																																																																																																																																																																																																																																																																																																											                                    width: 18,
																																																																																																																																																																																																																																																																																																																																																															                                      height: 18,
																																																																																																																																																																																																																																																																																																																																																																			                                        child: CircularProgressIndicator(
																																																																																																																																																																																																																																																																																																																																																																								                                    strokeWidth: 2,
																																																																																																																																																																																																																																																																																																																																																																												                                        color: Colors.white,
																																																																																																																																																																																																																																																																																																																																																																																	                                  ),
																																																																																																																																																																																																																																																																																																																																																																																					                                  )
																																																																																																																																																																																																																																																																																																																																																																																									                                : const Text('Sign in'),
																																																																																																																																																																																																																																																																																																																																																																																													                        ),
																																																																																																																																																																																																																																																																																																																																																																																																                      ],
																																																																																																																																																																																																																																																																																																																																																																																																		                          ),
																																																																																																																																																																																																																																																																																																																																																																																																					                    ),
																																																																																																																																																																																																																																																																																																																																																																																																							                    ),
																																																																																																																																																																																																																																																																																																																																																																																																									                    const SizedBox(height: 16),
																																																																																																																																																																																																																																																																																																																																																																																																											                    TextButton(
																																																																																																																																																																																																																																																																																																																																																																																																													                      onPressed: () => context.go('/onboarding'),
																																																																																																																																																																																																																																																																																																																																																																																																															                        child: const Text('New professional? Start onboarding'),
																																																																																																																																																																																																																																																																																																																																																																																																																		                ),
																																																																																																																																																																																																																																																																																																																																																																																																																				              ],
																																																																																																																																																																																																																																																																																																																																																																																																																					                  ),
																																																																																																																																																																																																																																																																																																																																																																																																																							            ),
																																																																																																																																																																																																																																																																																																																																																																																																																								            ),
																																																																																																																																																																																																																																																																																																																																																																																																																									          ),
																																																																																																																																																																																																																																																																																																																																																																																																																										      ),
																																																																																																																																																																																																																																																																																																																																																																																																																										        );
																																																																																																																																																																																																																																																																																																																																																																																																																											}

