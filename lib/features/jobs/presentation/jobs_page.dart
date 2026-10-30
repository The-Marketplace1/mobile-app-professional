import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../shared/widgets/section_card.dart';
import '../../shell/presentation/app_shell.dart';

class JobsPage extends ConsumerWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(appControllerProvider);
    return FeaturePageFrame(
      eyebrow: 'The work in motion',
      title: 'Jobs',
      body: controller.workspaceLoadError ?? 'Your scheduled and active work.',
      child: !controller.workspaceLoaded
          ? Center(
              child: controller.workspaceLoading
                  ? const CircularProgressIndicator()
                  : const Text('Job data is unavailable.'),
            )
          : controller.jobs.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No jobs found.')),
            )
          : Column(
              children: [
                for (final job in controller.jobs) ...[
                  SectionCard(
                    title: job.title,
                    subtitle: '${job.customer} · ${job.dateLabel}',
                    trailing: StatusPill(
                      job.status,
                      color: job.status == 'Completed'
                          ? AppTheme.teal
                          : AppTheme.ochre,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: AppTheme.muted,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            job.location,
                            style: const TextStyle(color: AppTheme.muted),
                          ),
                        ),
                        if (job.status != 'Completed')
                          TextButton(
                            onPressed: () async {
                              try {
                                final repository = ref.read(
                                  jobRepositoryProvider,
                                );
                                if (job.status == 'Scheduled') {
                                  await repository.start(job.id);
                                } else {
                                  await repository.complete(job.id);
                                  controller.completeJob(job.id);
                                }
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      job.status == 'Scheduled'
                                          ? 'Job started.'
                                          : 'Job completed.',
                                    ),
                                  ),
                                );
                              } catch (error) {
                                if (!context.mounted) return;
                                final message =
                                    error is ApiConfigurationException
                                    ? 'Configure the API Gateway before updating jobs.'
                                    : 'The job could not be updated. Please try again.';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                              }
                            },
                            child: Text(
                              job.status == 'Scheduled'
                                  ? 'Start job'
                                  : 'Complete',
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}

