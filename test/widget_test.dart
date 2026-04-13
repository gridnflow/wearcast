import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wearcast/features/home/presentation/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays WearCast text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    expect(find.text('WearCast'), findsOneWidget);
  });
}
