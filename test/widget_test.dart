import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:one_stop_editor/main.dart';
import 'package:one_stop_editor/screens/splash_screen.dart';

void main() {
  testWidgets('app boots with the main MaterialApp',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
