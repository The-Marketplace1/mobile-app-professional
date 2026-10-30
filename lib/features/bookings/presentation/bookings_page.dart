import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/models/domain.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../shared/widgets/section_card.dart';
import '../../shell/presentation/app_shell.dart';

class BookingsPage extends ConsumerWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(appControllerProvider);
    return FeaturePageFrame(
      eyebrow: 'Customer requests',
      title: 'Bookings',
      body: controller.workspaceLoadError ?? 'Review and manage your bookings.',
      child: !controller.workspaceLoaded
          ? Center(
              child: controller.workspaceLoading
                  ? const CircularProgressIndicator()
                  : const Text('Booking data is unavailable.'),
            )
          : controller.bookings.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No bookings found.')),
            )
          : Column(
              children: [
                for (final booking in controller.bookings) ...[
                  _BookingCard(booking: booking),
                  const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}

class _BookingCard extends ConsumerWidget {
  const _BookingCard({required this.booking});

  final BookingItem booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(appControllerProvider);
    final amount = booking.amount;
    final currency = controller.currencyCode;
    final details = [
      if (booking.address.isNotEmpty) booking.address,
      if (amount != null && currency != null && currency.isNotEmpty)
        NumberFormat.simpleCurrency(name: currency).format(amount),
    ].join(' · ');
    final pending = booking.status == BookingStatus.pending;
    return SectionCard(
      title: booking.service,
      subtitle: '${booking.dateLabel} · ${booking.timeLabel}',
      trailing: StatusPill(
        pending ? 'Needs reply' : 'Confirmed',
        color: pending ? AppTheme.ochre : AppTheme.teal,
      ),
      child: Column(
        children: [
          Row(
            children: [
              AvatarCircle(name: booking.customer),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.customer,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    if (details.isNotEmpty)
                      Text(
                        details,
                        style: const TextStyle(
                          color: AppTheme.muted,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
          if (pending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final reason = await _askDeclineReason(context);
                      if (reason == null || !context.mounted) return;
                      try {
                        await ref
                            .read(bookingRepositoryProvider)
                            .decline(id: booking.id, reason: reason);
                        if (!context.mounted) return;
                        controller.declineBooking(booking.id);
                        _showBookingMessage(context, 'Booking declined.');
                      } catch (error) {
                        if (context.mounted) _showBookingError(context, error);
                      }
                    },
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      try {
                        await ref
                            .read(bookingRepositoryProvider)
                            .accept(booking.id);
                        if (!context.mounted) return;
                        controller.acceptBooking(booking.id);
                        _showBookingMessage(context, 'Booking accepted.');
                      } catch (error) {
                        if (context.mounted) _showBookingError(context, error);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.navy,
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

Future<String?> _askDeclineReason(BuildContext context) async {
  final reason = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Decline this request?'),
      content: TextField(
        controller: reason,
        autofocus: true,
        maxLines: 2,
        decoration: const InputDecoration(labelText: 'Reason'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Keep booking'),
        ),
        FilledButton(
          onPressed: () {
            final value = reason.text.trim();
            if (value.isNotEmpty) Navigator.pop(dialogContext, value);
          },
          child: const Text('Decline'),
        ),
      ],
    ),
  );
  reason.dispose();
  return result;
}

void _showBookingMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void _showBookingError(BuildContext context, Object error) {
  final message = error is ApiConfigurationException
      ? 'Configure the API Gateway before changing bookings.'
      : 'The booking could not be updated. Please try again.';
  _showBookingMessage(context, message);
}

