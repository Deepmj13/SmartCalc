import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calculator/main.dart';

void main() {
  testWidgets('App loads home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SmartCalcApp()));

    expect(find.text('SmartCalc'), findsOneWidget);
    expect(find.text('EMI Calculator'), findsOneWidget);
    expect(find.text('GST Calculator'), findsOneWidget);
  });
}
