import 'package:flutter_test/flutter_test.dart';
import 'package:synq/main.dart';

void main() {
  testWidgets('Synq app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const SynqApp());
    expect(find.text('Dating'), findsOneWidget);
  });
}
