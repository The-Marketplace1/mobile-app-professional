import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../core/models/domain.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../bookings/presentation/bookings_page.dart';
import '../../communication/presentation/messages_page.dart';
import '../../dashboard/presentation/dashboard_page.dart';
import '../../jobs/presentation/jobs_page.dart';
import '../../more/presentation/more_page.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(appControllerProvider);
    final page = switch (controller.section) {
      AppSection.today => const DashboardPage(),
      AppSection.bookings => const BookingsPage(),
      AppSection.jobs => const JobsPage(),
      AppSection.messages => const MessagesPage(),
      AppSection.more => const MorePage(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const AppMark(compact: true),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              controller.select(AppSection.more);
            },
            icon: Badge(
              isLabelVisible: controller.notifications.any(
                (notification) => !notification.read,
              ),
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AvatarCircle(name: controller.profile.name),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (controller.workspaceLoadError != null)
              MaterialBanner(
                content: Text(controller.workspaceLoadError!),
                actions: [
                  TextButton(
                    onPressed: controller.loadWorkspace,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: KeyedSubtree(
                  key: ValueKey(controller.section),
                  child: page,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.section.index,
        onDestinationSelected: (index) {
          controller.select(AppSection.values[index]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline_rounded),
            selectedIcon: Icon(Icons.work_rounded),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class FeaturePageFrame extends StatelessWidget {
  const FeaturePageFrame({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.child,
    this.action,
  });

  final String eyebrow;
  final String title;
  final String body;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.only(bottom: 28),
    children: [
      SectionHeader(eyebrow: eyebrow, title: title, body: body, action: action),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    ],
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: onPressed,
    icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 17),
    label: Text(label),
    style: FilledButton.styleFrom(
      backgroundColor: AppTheme.navy,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    ),
  );
}

