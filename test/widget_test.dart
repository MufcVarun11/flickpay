import 'package:flutter_test/flutter_test.dart';

import 'package:varun_nair/app/flick_money_app.dart';

void main() {
  testWidgets('reward reveal screen renders the money moment', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlickMoneyApp());
    await tester.pump(const Duration(seconds: 4));

    expect(find.text('varun nair'), findsOneWidget);
    expect(find.text('MONEY'), findsOneWidget);
    expect(find.text('Single tap payments'), findsOneWidget);
    expect(find.text('Zero failures'), findsOneWidget);
    expect(find.text('Real-time refunds'), findsOneWidget);
    expect(find.text('Add Money'), findsOneWidget);
    expect(find.text('Claim Gift Card'), findsOneWidget);
    expect(find.text('Enjoy seamless\none tap payments'), findsOneWidget);
    expect(find.text('₹100 cashback'), findsNothing);
    expect(find.text('Flick again'), findsNothing);
  });

  testWidgets('add money action is available after reveal animation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlickMoneyApp());
    await tester.pump(const Duration(seconds: 4));

    await tester.ensureVisible(find.text('Add Money'));
    await tester.pump();
    await tester.tap(find.text('Add Money'));
    await tester.pump();

    expect(find.text('MONEY'), findsOneWidget);
  });
}
