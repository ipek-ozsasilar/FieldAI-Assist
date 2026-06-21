import 'package:flutter_test/flutter_test.dart';

import 'package:fieldai_assist/main.dart';

void main() {
  testWidgets('Home screen renders greeting and job cards', (tester) async {
    await tester.pumpWidget(const FieldAiAssistApp());

    expect(find.text('Hello, Ahmet Y.'), findsOneWidget);
    expect(find.text('FieldAI Assist'), findsOneWidget);
    expect(find.text('AI INSIGHT'), findsOneWidget);
    expect(find.text('Star Logistics'), findsOneWidget);
    expect(find.text('Open Job'), findsWidgets);
  });
}
