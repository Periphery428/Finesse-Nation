import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Add Event', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    test('Add Event UI Test', () async {
      // Build our app and trigger a frame.

//    // Add a new finesse for testing purposes
      await driver.tap(find.byValueKey('add event'));
      await driver.tap(find.byValueKey('name'));
//      await tester.enterText(find.byKey(Key('name')), 'Test Free Food');
//    await tester.enterText(
//        find.byKey(Key('location')), '201 N Goodwin Ave, Urbana, IL 61801');
//    await tester.enterText(find.byKey(Key('duration')), '60');
//    await tester.tap(find.byKey(Key('submit')));
//
//    // Verify that the new finesse was added
//    expect(find.text('Test Free Food'), findsOneWidget);
    });
  });
}
