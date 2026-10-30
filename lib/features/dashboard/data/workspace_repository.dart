import 'package:intl/intl.dart';

import '../../../core/models/domain.dart';
import '../../../core/network/api_client.dart';

class WorkspaceSnapshot {
  const WorkspaceSnapshot({
    required this.profile,
    required this.services,
    required this.bookings,
    required this.jobs,
    required this.conversations,
    required this.notifications,
    required this.reviews,
    required this.recentActivity,
    required this.availableBalance,
    required this.pendingBalance,
    required this.totalEarned,
    required this.thisMonth,
    required this.lastMonth,
    required this.currency,
    required this.completionRate,
  });

  final ProfessionalProfile profile;
  final List<ServiceItem> services;
  final List<BookingItem> bookings;
  final List<JobItem> jobs;
  final List<ConversationItem> conversations;
  final List<NotificationItem> notifications;
  final List<ReviewItem> reviews;
  final List<WorkspaceActivity> recentActivity;
  final int availableBalance;
  final int pendingBalance;
  final int totalEarned;
  final int? thisMonth;
  final int? lastMonth;
  final String? currency;
  final double completionRate;
}

class WorkspaceActivity {
  const WorkspaceActivity({
    required this.type,
    required this.description,
    required this.timeLabel,
  });

  final String type;
  final String description;
  final String timeLabel;
}

class WorkspaceRepository {
  const WorkspaceRepository(this._api);

  final ApiClient _api;

  Future<WorkspaceSnapshot> load() async {
    final responses = await Future.wait<Object?>([
      _api
          .get<Map<String, dynamic>>('profile')
          .then((response) => response.data),
      _api.get<List<dynamic>>('services').then((response) => response.data),
      _api
          .get<Map<String, dynamic>>('bookings')
          .then((response) => response.data),
      _api.get<List<dynamic>>('jobs').then((response) => response.data),
      _api
          .get<List<dynamic>>('conversations')
          .then((response) => response.data),
      _api
          .get<List<dynamic>>('notifications')
          .then((response) => response.data),
      _api
          .get<Map<String, dynamic>>(
            'reviews',
            queryParameters: {'limit': 50, 'offset': 0},
          )
          .then((response) => response.data),
      _api
          .get<Map<String, dynamic>>('payments/earnings-summary')
          .then((response) => response.data),
      _api
          .get<Map<String, dynamic>>('analytics/dashboard')
          .then((response) => response.data),
    ]);

    final profile = _asMap(responses[0], 'profile');
    final services = _asList(responses[1], 'services');
    final bookings = _asMap(responses[2], 'bookings');
    final jobs = _asList(responses[3], 'jobs');
    final conversations = _asList(responses[4], 'conversations');
    final notifications = _asList(responses[5], 'notifications');
    final reviews = _asMap(responses[6], 'reviews');
    final earnings = _asMap(responses[7], 'earnings');
    final analytics = _asMap(responses[8], 'dashboard analytics');
    final completionRate = _number(
      analytics['completionRate'],
      'analytics.completionRate',
    ).toDouble();
    final rawActivity = analytics['recentActivity'];
    final recentActivity = rawActivity == null
        ? <WorkspaceActivity>[]
        : _asList(
            rawActivity,
            'dashboard recent activity',
          ).map(_activity).toList(growable: false);

    return WorkspaceSnapshot(
      profile: _profile(profile),
      services: services.map(_service).toList(growable: false),
      bookings: _asList(
        bookings['items'],
        'booking items',
      ).map(_booking).toList(growable: false),
      jobs: jobs.map(_job).toList(growable: false),
      conversations: conversations.map(_conversation).toList(growable: false),
      notifications: notifications.map(_notification).toList(growable: false),
      reviews: _asList(
        reviews['items'],
        'review items',
      ).map(_review).toList(growable: false),
      recentActivity: recentActivity,
      availableBalance: _number(
        earnings['availableBalance'],
        'earnings.availableBalance',
      ).round(),
      pendingBalance: _number(
        earnings['pendingBalance'],
        'earnings.pendingBalance',
      ).round(),
      totalEarned: _number(
        earnings['totalEarned'],
        'earnings.totalEarned',
      ).round(),
      thisMonth: _optionalNumber(earnings['thisMonth'])?.round(),
      lastMonth: _optionalNumber(earnings['lastMonth'])?.round(),
      currency: _optionalString(earnings['currency']),
      completionRate: completionRate <= 1
          ? completionRate * 100
          : completionRate,
    );
  }

  ProfessionalProfile _profile(Map<String, dynamic> data) {
    final first = _string(data['firstName'], 'profile.firstName');
    final last = _string(data['lastName'], 'profile.lastName');
    return ProfessionalProfile(
      name: [first, last].where((part) => part.isNotEmpty).join(' '),
      businessName: _optionalString(data['businessName']) ?? '',
      email: _string(data['email'], 'profile.email'),
      location: _optionalString(data['serviceArea']) ?? '',
      rating: _optionalNumber(data['rating'])?.toDouble(),
      reviewCount: _optionalNumber(data['totalReviews'])?.toInt(),
      verificationStatus: _optionalString(data['verificationStatus']),
    );
  }

  ServiceItem _service(Object? value) {
    final data = _asMap(value, 'service');
    return ServiceItem(
      id: _string(data['id'], 'service.id'),
      title: _string(data['title'], 'service.title'),
      category: _string(data['category'], 'service.category'),
      description: _optionalString(data['description']) ?? '',
      price: _number(data['price'], 'service.price').round(),
      durationMinutes: _number(data['duration'], 'service.duration').toInt(),
      active: data['isActive'] == true,
    );
  }

  BookingItem _booking(Object? value) {
    final data = _asMap(value, 'booking');
    final service = _asMap(data['service'], 'booking.service');
    final customer = _asMap(data['customer'], 'booking.customer');
    final scheduledAt = DateTime.parse(
      _string(data['scheduledAt'], 'booking.scheduledAt'),
    );
    return BookingItem(
      id: _string(data['id'], 'booking.id'),
      customer: _string(customer['name'], 'booking.customer.name'),
      service: _string(service['title'], 'booking.service.title'),
      dateLabel: DateFormat('EEEE, MMMM d').format(scheduledAt),
      timeLabel: DateFormat('h:mm a').format(scheduledAt),
      address:
          _optionalString(data['address']) ??
          'Address shared after confirmation',
      amount: _optionalNumber(data['totalAmount'])?.round(),
      status: _bookingStatus(_string(data['status'], 'booking.status')),
    );
  }

  JobItem _job(Object? value) {
    final data = _asMap(value, 'job');
    final booking = _asMap(data['booking'], 'job.booking');
    final service = _asMap(booking['service'], 'job.booking.service');
    final customer = _asMap(booking['customer'], 'job.booking.customer');
    final scheduledAt = DateTime.parse(
      _string(booking['scheduledAt'], 'job.booking.scheduledAt'),
    );
    return JobItem(
      id: _string(data['id'], 'job.id'),
      title: _string(service['title'], 'job.booking.service.title'),
      customer: _string(customer['name'], 'job.booking.customer.name'),
      status: _jobStatus(_string(data['status'], 'job.status')),
      dateLabel: DateFormat('EEE · h:mm a').format(scheduledAt),
      location:
          _optionalString(booking['address']) ??
          'Address shared after confirmation',
    );
  }

  ConversationItem _conversation(Object? value) {
    final data = _asMap(value, 'conversation');
    final customer = _asMap(data['customer'], 'conversation.customer');
    final lastMessageAt = DateTime.parse(
      _string(data['lastMessageAt'], 'conversation.lastMessageAt'),
    );
    return ConversationItem(
      id: _string(data['id'], 'conversation.id'),
      customer: _string(customer['name'], 'conversation.customer.name'),
      preview: _optionalString(data['lastMessage']) ?? '',
      timeLabel: DateFormat('MMM d, h:mm a').format(lastMessageAt),
      unread: _optionalNumber(data['unreadCount'])?.toInt() ?? 0,
      online: data['isOnline'] == true,
    );
  }

  NotificationItem _notification(Object? value) {
    final data = _asMap(value, 'notification');
    return NotificationItem(
      id: _string(data['id'], 'notification.id'),
      title: _string(data['title'], 'notification.title'),
      body: _optionalString(data['body']) ?? '',
      timeLabel: DateFormat('MMM d, h:mm a').format(
        DateTime.parse(_string(data['createdAt'], 'notification.createdAt')),
      ),
      kind: _string(data['type'], 'notification.type'),
      read: data['isRead'] == true,
    );
  }

  ReviewItem _review(Object? value) {
    final data = _asMap(value, 'review');
    final customer = _asMap(data['customer'], 'review.customer');
    final serviceValue = data['service'];
    final service = serviceValue == null
        ? <String, dynamic>{}
        : _asMap(serviceValue, 'review.service');
    return ReviewItem(
      id: _string(data['id'], 'review.id'),
      customer: _string(customer['name'], 'review.customer.name'),
      comment: _optionalString(data['comment']) ?? '',
      rating: _number(data['rating'], 'review.rating').round(),
      service: _optionalString(service['title']) ?? '',
      response: _optionalString(data['response']),
    );
  }

  WorkspaceActivity _activity(Object? value) {
    final data = _asMap(value, 'dashboard activity');
    return WorkspaceActivity(
      type: _string(data['type'], 'activity.type'),
      description: _string(data['description'], 'activity.description'),
      timeLabel: DateFormat('MMM d, h:mm a').format(
        DateTime.parse(_string(data['occurredAt'], 'activity.occurredAt')),
      ),
    );
  }

  BookingStatus _bookingStatus(String value) {
    final normalized = value.toLowerCase().replaceAll('-', '_');
    return switch (normalized) {
      'pending' => BookingStatus.pending,
      'confirmed' => BookingStatus.confirmed,
      'assigned' => BookingStatus.assigned,
      'accepted' => BookingStatus.accepted,
      'en_route' || 'enroute' => BookingStatus.enRoute,
      'arriving' => BookingStatus.arriving,
      'arrived' => BookingStatus.arrived,
      'in_progress' || 'inprogress' => BookingStatus.inProgress,
      'completed' => BookingStatus.completed,
      'cancelled' || 'canceled' => BookingStatus.cancelled,
      _ => throw FormatException('Unknown booking status: $value'),
    };
  }

  String _jobStatus(String value) => switch (value.toLowerCase()) {
    'scheduled' => 'Scheduled',
    'in_progress' || 'in progress' => 'In progress',
    'paused' => 'Paused',
    'completed' => 'Completed',
    _ => value,
  };

  Map<String, dynamic> _asMap(Object? value, String field) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    throw FormatException('Gateway returned invalid $field data.');
  }

  List<dynamic> _asList(Object? value, String field) {
    if (value is List) return value;
    throw FormatException('Gateway returned invalid $field data.');
  }

  String _string(Object? value, String field) {
    if (value is String) return value;
    throw FormatException('Gateway omitted $field.');
  }

  String? _optionalString(Object? value) => value is String ? value : null;

  num _number(Object? value, String field) {
    if (value is num) return value;
    throw FormatException('Gateway omitted $field.');
  }

  num? _optionalNumber(Object? value) => value is num ? value : null;
}

