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
      await driver.enterText('Integration Test Free Food');
      await driver.tap(find.byValueKey('location'));
      await driver.enterText('Integration Test Location');
      await driver.tap(find.byValueKey('submit'));
      expect(await driver.getText(find.byValueKey('title')),
          "Integration Test Free Food");
    });
  });
}
