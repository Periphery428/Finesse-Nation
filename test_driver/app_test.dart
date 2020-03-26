import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future<void> delay([int milliseconds = 250]) async {
  await Future<void>.delayed(Duration(milliseconds: milliseconds));
}

//Fill out the form with the necessary information.
Future<void> addEvent(FlutterDriver driver, nameText, locationText,
    descriptionText, durationText) async {
  await driver.tap(find.byValueKey('add event'));

  await driver.tap(find.byValueKey('name'));
  await driver.enterText(nameText);
  await driver.waitFor(find.text(nameText));

  await driver.tap(find.byValueKey('location'));
  await driver.enterText(locationText);
  await driver.waitFor(find.text(locationText));

  await driver.tap(find.byValueKey('description'));
  await driver.enterText(descriptionText);
  await driver.waitFor(find.text(descriptionText));

  await driver.tap(find.byValueKey('duration'));
  await driver.enterText(durationText);
  await driver.waitFor(find.text(durationText));

  await driver.tap(find.byValueKey('submit'));
}

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

    test('Add Event Form Fail Test', () async {
      await driver.tap(find.byType("AnimatedButton"));
      await delay(1000);
      String nameText = 'Integration Test Free Food';
      String descriptionText =
          'The location is a timestamp to make a unique value for the test to look for.';
      String durationText = 'Integration Test Duration';
      String locationText = '';

      await addEvent(
          driver, nameText, locationText, descriptionText, durationText);
      await delay(1000);

      expect(await driver.getText(find.text("Please Enter a Location")),
          "Please Enter a Location");

      await driver.tap(find.byTooltip('Back'));

      expect(
          await driver.getText(find.text("Finesse Nation")), "Finesse Nation");
    });

    test('Add Event UI Test', () async {
      // Build our app and trigger a frame.
      String nameText = 'Integration Test Free Food';
      String durationText = 'Integration Test Duration';
      String descriptionText =
          'The location is a timestamp to make a unique value for the test to look for.';
      var now = new DateTime.now();
      String locationText = 'Location: ' + now.toString();

      await addEvent(
          driver, nameText, locationText, descriptionText, durationText);
      await delay(1000);

      expect(await driver.getText(find.text(locationText)), locationText);
    });
  });

  group('Finesse Page', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('View Info Test', () async {
      // Build our app and trigger a frame.
      String nameText = 'View Info Integration Test Free Food';
      String durationText = 'Integration Test Duration';
      String descriptionText = 'View Info description';
      var now = new DateTime.now();
      String locationText = 'Location: ' + now.toString();
      await addEvent(
          driver, nameText, locationText, descriptionText, durationText);
      await delay(1000);
      await driver.tap(find.text(locationText));
      await delay(1000);
      await driver.getText(find.text(descriptionText));
      await driver.getText(find.text(durationText));
      await driver.getText(find.text(locationText));
    });
  });
}
