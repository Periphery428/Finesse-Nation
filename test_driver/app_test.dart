import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future<void> delay([int milliseconds = 250]) async {
  await Future<void>.delayed(Duration(milliseconds: milliseconds));
}

//Fill out the form with the necessary information.
Future<void> addEvent(
    FlutterDriver driver, nameText, locationText, descriptionText, durationText,
    {bool takePic: false}) async {
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
  print('logging in...');
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

void main() {
  group('Login', () {
    FlutterDriver driver;

    setUpAll(() async {
      print('setting up');
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Successful login', () async {
      await login(driver);
      await driver.tap(find.byValueKey('logoutButton'));
    });

    test('Successful registration', () async {
      String uniqueEmail =
          DateTime.now().millisecondsSinceEpoch.toString() + '@test.com';
      await login(driver, email: uniqueEmail, signUp: true);
      await driver.tap(find.byValueKey('logoutButton'));
      await login(driver, email: uniqueEmail);
      await driver.tap(find.byValueKey('logoutButton'));
    });

    test('Missing information', () async {
      String badEmail = "Email can't be empty",
          badPass = "Password must be at least 6 characters";

      await login(driver, email: '', password: '');
      await driver.getText(find.text(badEmail));
      await driver.getText(find.text(badPass));
    });

    test('Invalid email', () async {
      String badEmail = "Invalid email address";

      await login(driver, email: 'invalidemail.com');
      await driver.getText(find.text(badEmail));
    });
  });

  group('Add Event', () {
    FlutterDriver driver;

    setUpAll(() async {
      print('setting up');
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Add Event Form Fail Test', () async {
      await login(driver);
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
  group('Filters ', () {
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
      // Build our app and trigger a frame.
//      var now = new DateTime.now();
//      String location = now.toString();
//      Finesse newFinesse = await addFinesseHelper(location);
//
//      await driver.getText(find.text(location));

      await driver.tap(find.byValueKey("Filter"));
      await driver.tap(find.byValueKey("activeFilter"));
      await driver.tap(find.byValueKey("FilterOK"));

//      bool found = await isPresent(find.text(location), driver);
//
//      expect(found, false);
    });

    test('Filter Other', () async {
      // Build our app and trigger a frame.
      await driver.tap(find.byValueKey("Filter"));
      await driver.tap(find.byValueKey("typeFilter"));
      await driver.tap(find.byValueKey("FilterOK"));
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
      await driver.tap(find.pageBack());
    });

  });

  group('Maps Link', () {
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
      var now = new DateTime.now();
      String nameText = 'Maps Test ${now.toString()}';
      String durationText = 'Integration Test Duration';
      String descriptionText = 'View Info description';
      String locationText = 'Siebel Center';
      await addEvent(
          driver, nameText, locationText, descriptionText, durationText);
      await delay(1000);
      await driver.tap(find.text(nameText));
      await delay(1000);
      await driver.tap(find.text(locationText));
      await delay(1000);
    });
  });
}
