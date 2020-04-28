import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future<void> delay([int milliseconds = 250]) async {
  await Future<void>.delayed(Duration(milliseconds: milliseconds));
}

/// Fill out the form with the necessary information.
Future<void> addEvent(FlutterDriver driver, nameText, locationText,
    {String descriptionText = "Integration Test Description",
    String durationText = "Integration Test Duration",
    bool takePic: false}) async {
  nameText = "Integration Test " + nameText;
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
  if (locationText != '') {
    await delay(1000);
    expect(await driver.getText(find.text("now")), "now");
  }
}

Future<bool> isPresent(SerializableFinder finder, FlutterDriver driver,
    {Duration timeout = const Duration(seconds: 5)}) async {
  try {
    await driver.waitFor(finder, timeout: timeout);
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> login(FlutterDriver driver,
    {email: 'test@test.com', password: 'test123', signUp: false}) async {
  await driver.tap(find.byValueKey('emailField'));
  await driver.enterText(email);
  await driver.tap(find.byValueKey("passwordField"));
  await driver.enterText(password);
  if (signUp) {
    await driver.tap(find.byValueKey('switchButton'));
    await driver.tap(find.byValueKey("confirmField"));
    await driver.enterText(password);
  }
  await driver.tap(find.byValueKey("loginButton"));
}

Future<void> logout(FlutterDriver driver) async {
  await gotoSettings(driver);
  await driver.tap(find.byValueKey("logoutButton"));
}

Future gotoSettings(FlutterDriver driver) async {
  await driver.tap(find.byValueKey("dropdownButton"));
  await driver.tap(find.byValueKey("settingsButton"));
}

Future<void> markAsEnded(FlutterDriver driver, String locationText) async {
  await driver.tap(find.text(locationText));
  await driver.tap(find.byValueKey("threeDotButton"));
  await driver.tap(find.byValueKey("markAsEndedButton"));
  await driver.tap(find.pageBack());
}

void main() {
  group('Login:', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Successful login', () async {
      await login(driver);
      await logout(driver);
    });

    test('Successful registration', () async {
      String uniqueEmail =
          DateTime.now().millisecondsSinceEpoch.toString() + '@test.com';
      await login(driver, email: uniqueEmail, signUp: true);
      await logout(driver);
      await login(driver, email: uniqueEmail);
      await logout(driver);
    });

    test('Missing information', () async {
      String badEmail = "Email can't be empty",
          badPass = "Password must be at least 6 characters";

      await login(driver, email: '', password: '');
      await driver.getText(find.text(badEmail));
      await driver.getText(find.text(badPass));
    });

    test('Invalid email', () async {
      String errorText = "Invalid email address";

      await login(driver, email: 'invalidemail.com');
      await driver.getText(find.text(errorText));
    });
  });

  group('Add Event:', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Add event form fail test', () async {
      await login(driver);
      String testName = 'Add event form fail test';
      String locationText = '';

      await addEvent(driver, testName, locationText);

      expect(await driver.getText(find.text("Please enter a location")),
          "Please enter a location");

      await driver.tap(find.byTooltip('Back'));
    });

    test('Add a finesse', () async {
      String testName = 'Add a finesse';
      String locationText = generateUniqueLocationText();

      await addEvent(driver, testName, locationText);

      expect(await driver.getText(find.text(locationText)), locationText);
      await delay(1000);
      await markAsEnded(driver, locationText);
    });
  });

  group('Filters:', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Filter active', () async {
      await driver.tap(find.byValueKey("Filter"));
      await driver.tap(find.byValueKey("activeFilter"));
      await driver.tap(find.byValueKey("FilterOK"));
    });

    test('Filter Other', () async {
      await driver.tap(find.byValueKey("Filter"));
      await driver.tap(find.byValueKey("typeFilter"));
      await driver.tap(find.byValueKey("FilterOK"));
    });
  });

  group('Settings Page:', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Settings Page ', () async {
      // Build our app and trigger a frame.
      await gotoSettings(driver);
      await driver.tap(find.byValueKey("Notification Toggle"));
      await driver.tap(find.pageBack());
      await gotoSettings(driver);
      await driver.tap(find.byValueKey("Notification Toggle"));
      await driver.tap(find.pageBack());
    });
  });

  group('Finesse Page:', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('View finesse info', () async {
      // Build our app and trigger a frame.
      String testName = 'View finesse info';
      String locationText = generateUniqueLocationText();

      await addEvent(driver, testName, locationText);

      await driver.tap(find.text(locationText));
      await delay(1000);
      await driver.getText(find.text(locationText));
      await driver.tap(find.pageBack());
      await delay(5000);
      await markAsEnded(driver, locationText);
    });
  });

  group('Mark as Expired:', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Add event then mark as expired', () async {
      String testName = 'Add event then mark as expired';
      String locationText = generateUniqueLocationText();
      await addEvent(driver, testName, locationText);
      await markAsEnded(driver, locationText);
    });
  });

  group('Maps Link:', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('View Map Test', () async {
      // Build our app and trigger a frame.
      var now = DateTime.now();
      String nameText = 'Maps Test ${now.toString()}';
      String locationText = 'Siebel Center';
      await addEvent(driver, nameText, locationText);
      await driver.tap(find.text('Integration Test ' + nameText));
      await delay(1000);
      await driver.tap(find.byValueKey("threeDotButton"));
      await delay(1000);
      await driver.tap(find.byValueKey("markAsEndedButton"));
      await delay(1000);
      await driver.tap(find.text(locationText));
      await delay(1000);
      await driver.tap(find.text(locationText));
      await delay(1000);
    });
  });
}

String generateUniqueLocationText() {
  var now = DateTime.now();
  String locationText = 'Location: ' + now.toString();
  return locationText;
}
