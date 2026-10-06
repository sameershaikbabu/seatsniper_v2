import 'package:flutter_test/flutter_test.dart';

import 'package:seatsniper_v2/main.dart';

void main() {
  testWidgets('SeatSniper app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SeatSniperApp());

    expect(find.text('SEATSNIPER'), findsOneWidget);
    expect(
      find.text('AI-Powered Instant Ticket Booking'),
      findsOneWidget,
    );
  });
}