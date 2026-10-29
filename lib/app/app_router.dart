import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../core/network/api_client.dart';
import '../core/storage/secure_session_storage.dart';
import '../core/storage/session_store.dart';
import '../features/availability/data/availability_repository.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/bookings/data/booking_repository.dart';
import '../features/communication/data/communication_repository.dart';
import '../features/disputes/data/dispute_repository.dart';
import '../features/dashboard/data/workspace_repository.dart';
import '../features/earnings/data/earnings_repository.dart';
import '../features/jobs/data/job_repository.dart';
import '../features/profile/data/profile_repository.dart';
import '../features/reviews/data/review_repository.dart';
import '../features/services/data/service_repository.dart';
import '../features/settings/data/settings_repository.dart';
import '../features/verification/data/verification_repository.dart';
import '../features/withdrawals/data/withdrawal_repository.dart';
import '../features/auth/presentation/auth_page.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/shell/presentation/app_shell.dart';
import '../features/verification/presentation/verification_page.dart';
import 'app_controller.dart';

final sessionStoreProvider = Provider<SessionStore>(
  (ref) => const SecureSessionStorage(FlutterSecureStorage()),
);

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(sessionStorage: ref.watch(sessionStoreProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    sessionStore: ref.watch(sessionStoreProvider),
  ),
);

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(ref.watch(apiClientProvider)),
);
final verificationRepositoryProvider = Provider(
  (ref) => VerificationRepository(ref.watch(apiClientProvider)),
);
final serviceRepositoryProvider = Provider(
  (ref) => ServiceRepository(ref.watch(apiClientProvider)),
);
final availabilityRepositoryProvider = Provider(
  (ref) => AvailabilityRepository(ref.watch(apiClientProvider)),
);
final bookingRepositoryProvider = Provider(
  (ref) => BookingRepository(ref.watch(apiClientProvider)),
);
final jobRepositoryProvider = Provider(
  (ref) => JobRepository(ref.watch(apiClientProvider)),
);
final communicationRepositoryProvider = Provider(
  (ref) => CommunicationRepository(ref.watch(apiClientProvider)),
);
final workspaceRepositoryProvider = Provider(
  (ref) => WorkspaceRepository(ref.watch(apiClientProvider)),
);
final earningsRepositoryProvider = Provider(
  (ref) => EarningsRepository(ref.watch(apiClientProvider)),
);
final withdrawalRepositoryProvider = Provider(
  (ref) => WithdrawalRepository(ref.watch(apiClientProvider)),
);
final reviewRepositoryProvider = Provider(
  (ref) => ReviewRepository(ref.watch(apiClientProvider)),
);
final disputeRepositoryProvider = Provider(
  (ref) => DisputeRepository(ref.watch(apiClientProvider)),
);
final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(ref.watch(apiClientProvider)),
);

final appControllerProvider = ChangeNotifierProvider<AppController>(
  (ref) => AppController(
    workspaceRepository: ref.watch(workspaceRepositoryProvider),
  ),
);

GoRouter createAppRouter(AppController controller) => GoRouter(
  initialLocation: '/auth',
  refreshListenable: controller,
  redirect: (context, state) {
    final isAuth = state.matchedLocation == '/auth';
    if (!controller.authenticated && !isAuth) return '/auth';
    if (controller.authenticated && isAuth) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/verification',
      builder: (context, state) => const VerificationPage(),
    ),
    GoRoute(path: '/', builder: (context, state) => const AppShell()),
  ],
);
