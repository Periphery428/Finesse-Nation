import 'package:finesse_nation/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add Event UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

//    // Add a new finesse for testing purposes
    await tester.tap(find.byKey(Key('add event')));
//      await tester.enterText(find.byKey(Key('name')), 'Test Free Food');
//    await tester.enterText(
//        find.byKey(Key('location')), '201 N Goodwin Ave, Urbana, IL 61801');
//    await tester.enterText(find.byKey(Key('duration')), '60');
//    await tester.tap(find.byKey(Key('submit')));
//
//    // Verify that the new finesse was added
//    expect(find.text('Test Free Food'), findsOneWidget);
  });


  testWidgets('Add Image UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

//    // Add a new finesse for testing purposes
    await tester.tap(find.byKey(Key('add event')));
//      await tester.enterText(find.byKey(Key('name')), 'Test Free Food');
//    await tester.enterText(
//        find.byKey(Key('location')), '201 N Goodwin Ave, Urbana, IL 61801');
//    await tester.enterText(find.byKey(Key('duration')), '60');
//    await tester.tap(find.byKey(Key('submit')));
//
//    // Verify that the new finesse was added
//    expect(find.text('Test Free Food'), findsOneWidget);
  });
}
