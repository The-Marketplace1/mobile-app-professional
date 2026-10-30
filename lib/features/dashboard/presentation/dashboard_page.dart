import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/models/domain.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../shared/widgets/section_card.dart';
import '../../shell/presentation/app_shell.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(appControllerProvider);
    final firstName = controller.profile.name
        .trim()
        .split(RegExp(r'\s+'))
        .first;
    if (!controller.workspaceLoaded) {
      return FeaturePageFrame(
        eyebrow: DateFormat('EEEE · MMMM d').format(DateTime.now()),
        title: firstName.isEmpty ? 'Today' : 'Welcome, $firstName.',
        body:
            controller.workspaceLoadError ??
            (controller.workspaceLoading
                ? 'Loading workspace data.'
                : 'Workspace data is unavailable.'),
        child: Center(
          child: controller.workspaceLoading
              ? const CircularProgressIndicator()
              : TextButton.icon(
                  onPressed: controller.loadWorkspace,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
        ),
      );
    }
    final nextBooking = controller.bookings.isEmpty
        ? null
        : controller.bookings.first;
    final pendingCount = controller.bookings
        .where((booking) => booking.status == BookingStatus.pending)
        .length;

    return FeaturePageFrame(
      eyebrow: DateFormat('EEEE · MMMM d').format(DateTime.now()),
      title: firstName.isEmpty ? 'Today' : 'Welcome, $firstName.',
      body: pendingCount == 0
          ? 'Your professional workspace.'
          : '$pendingCount booking requests need your reply.',
      action: PrimaryButton(
        label: 'Add a service',
        icon: Icons.add_rounded,
        onPressed: () => controller.select(AppSection.more),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 650 ? 4 : 2;
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: columns == 4 ? 1.28 : 1.12,
                children: [
                  MetricCard(
                    label: 'Available to withdraw',
                    value: _money(
                      controller.availableToWithdraw,
                      controller.currencyCode,
                    ),
                    caption:
                        '${_money(controller.pendingBalance, controller.currencyCode)} pending release',
                    icon: Icons.account_balance_wallet_outlined,
                    accent: AppTheme.teal,
                  ),
                  MetricCard(
                    label: 'Pending requests',
                    value: '$pendingCount',
                    caption: pendingCount == 0
                        ? 'All requests are up to date'
                        : 'Awaiting your reply',
                    icon: Icons.calendar_today_outlined,
                    accent: AppTheme.ochre,
                  ),
                  MetricCard(
                    label: 'Completion rate',
                    value: '${controller.completionRate.toStringAsFixed(0)}%',
                    caption: 'Marketplace performance',
                    icon: Icons.monitor_heart_outlined,
                  ),
                  MetricCard(
                    label: 'Average rating',
                    value: controller.profile.rating?.toStringAsFixed(1) ?? '—',
                    caption: controller.profile.reviewCount == null
                        ? 'Review count unavailable'
                        : '${controller.profile.reviewCount} customer reviews',
                    icon: Icons.star_outline_rounded,
                    accent: AppTheme.ochre,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Next up',
            subtitle: 'Your schedule at a glance',
            trailing: TextButton(
              onPressed: () => controller.select(AppSection.bookings),
              child: const Text('View all'),
            ),
            child: nextBooking == null
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('No upcoming bookings.'),
                  )
                : ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 48,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppTheme.navy,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      nextBooking.service,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      '${nextBooking.timeLabel} · ${nextBooking.customer}\n${nextBooking.address}',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SectionCard(
                  title: 'Earned so far',
                  subtitle: 'This month',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _money(controller.thisMonthEarned, controller.currencyCode),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Last month: ${_money(controller.lastMonthEarned, controller.currencyCode)}',
                        style: const TextStyle(
                          color: AppTheme.teal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SectionCard(
                  title: 'Recent activity',
                  subtitle: 'A quick look back',
                  child: controller.recentActivity.isEmpty
                      ? const Text('No recent activity.')
                      : Column(
                          children: [
                            for (final item
                                in controller.recentActivity.take(3))
                              _ActivityRow(
                                icon: _activityIcon(item.type),
                                title: item.description,
                                detail: item.timeLabel,
                              ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _money(num? amount, String? currency) {
  if (amount == null || currency == null || currency.isEmpty) return '—';
  return NumberFormat.simpleCurrency(name: currency).format(amount);
}

IconData _activityIcon(String type) => switch (type.toLowerCase()) {
  'payment' || 'payout' => Icons.payments_outlined,
  'review' => Icons.star_outline_rounded,
  'booking' => Icons.calendar_today_outlined,
  _ => Icons.notifications_none_rounded,
};

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Row(
      children: [
        Icon(icon, size: 19, color: AppTheme.teal),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(color: AppTheme.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

