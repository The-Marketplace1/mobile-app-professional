import 'package:flutter_test/flutter_test.dart';
import 'package:professional_app/features/maps/domain/job_location_policy.dart';

void main() {
  group('JobLocationPermission', () {
    test('requires an active job and Gateway authorization', () {
      expect(
        const JobLocationPermission(
          jobIsActive: true,
          authorizedByGateway: true,
        ).canCapture,
        isTrue,
      );
      expect(
        const JobLocationPermission(
          jobIsActive: false,
          authorizedByGateway: true,
        ).canCapture,
        isFalse,
      );
      expect(
        const JobLocationPermission(
          jobIsActive: true,
          authorizedByGateway: false,
        ).canCapture,
        isFalse,
      );
    });
  });
}

