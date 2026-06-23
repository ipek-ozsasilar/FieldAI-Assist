import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fieldai_assist/main.dart';

void main() {
  testWidgets('Home screen renders initial loading state and AI action', (
    tester,
  ) async {
    await tester.pumpWidget(const FieldAiAssistApp());

    expect(find.text('Hello, Ahmet Y.'), findsOneWidget);
    expect(find.text('FieldAI Assist'), findsOneWidget);
    expect(find.text('AI önerisi'), findsOneWidget);
    expect(find.text('AI önerisi henüz yok.'), findsOneWidget);
    expect(find.text('AI ile Önceliklendir'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
