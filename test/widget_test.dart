import 'package:flutter_test/flutter_test.dart';
import 'package:tiu_adaptive/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TiuAdaptiveApp());
    expect(find.text('TIU ADAPTIVE'), findsNothing);
  });
}
