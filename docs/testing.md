# Testing

- `test/unit/`: domain/state and policy tests
- `test/widget_test.dart`: app startup and form behavior
- `integration_test/`: Android/iOS end-to-end smoke flows

Run unit and widget tests with `flutter test`. Run the end-to-end test with an
Android emulator:

```sh
flutter test integration_test/professional_app_e2e_test.dart -d emulator-5554
```

Authentication test dependencies are isolated under `test/` and are never used
by the shipped app or used to replace Gateway behavior.

