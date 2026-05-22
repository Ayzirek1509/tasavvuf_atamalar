import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tasavvuf_terms/main.dart';
import 'package:tasavvuf_terms/utils/theme_provider.dart';

void main() {
  testWidgets('Welcome screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const TasavvufApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Boshlash'), findsOneWidget);
  });
}
