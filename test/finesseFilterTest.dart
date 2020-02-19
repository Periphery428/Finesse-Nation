// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:finesse_nation/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Check filter function smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Select some filter options
    await tester.tap(find.byKey(Key('filter')));
    await tester.tap(find.byKey(Key('Italian')));
    await tester.tap(find.byKey(Key('Japanese')));
    await tester.tap(find.byKey(Key('Mexican')));
    await tester.tap(find.byKey(Key('3 hours ago')));
    await tester.tap(find.byKey(Key('Apply')));

    // Verify that the the finesse events will filtered given their selected options
    expect(find.text('Pizza'), findsOneWidget);
    expect(find.text('Sushi'), findsOneWidget);
    expect(find.text('Tacos'), findsOneWidget);
  });
}
