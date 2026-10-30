import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:professional_app/app/app.dart';
import 'package:professional_app/app/app_router.dart';

import '../test/support/fake_auth_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('new professionals can reach onboarding from sign in', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: const ProfessionalApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('New professional? Start onboarding'));
    await tester.pumpAndSettle();

    expect(find.text('STEP 1 OF 3'), findsOneWidget);
    expect(find.text('Your professional profile'), findsOneWidget);
    expect(find.text('Basic information'), findsOneWidget);
  });
}

