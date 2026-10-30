import 'package:flutter_test/flutter_test.dart';
import 'package:professional_app/app/app_controller.dart';
import 'package:professional_app/core/models/domain.dart';

void main() {
  group('AppController', () {
    test('accepting a booking updates its status', () {
      final controller = AppController();

      controller.acceptBooking('BK-1048');

      expect(controller.bookings.first.status, BookingStatus.accepted);
    });

    test('withdrawal requests enforce the available balance', () {
      final controller = AppController();
      final startingBalance = controller.availableToWithdraw;

      controller.requestWithdrawal(startingBalance + 1);
      expect(controller.availableToWithdraw, startingBalance);

      controller.requestWithdrawal(500);
      expect(controller.availableToWithdraw, startingBalance - 500);
    });

    test('unknown service IDs do not change any services', () {
      final controller = AppController();

      controller.toggleService('unknown');

      expect(controller.services.every((service) => service.active), isTrue);
    });
  });
}

