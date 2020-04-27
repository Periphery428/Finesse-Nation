import 'dart:async';
import 'package:finesse_nation/Comment.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/User.dart';
import 'package:finesse_nation/login/flutter_login.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

Future<Finesse> addFinesseHelper([name]) async {
  var now = new DateTime.now();
  Finesse newFinesse = Finesse.finesseAdd(
      name ?? "Add Event unit test",
      "Description:" + now.toString(),
      null,
      "Activities and Recreation Center",
      "60 hours",
      "Food",
      new DateTime.now());
  await Network.addFinesse(newFinesse);
  return newFinesse;
}

List<Finesse> createFinesseList({String type = "Food", List isActive}) {
  List<Finesse> finesseList = [];

  for (var i = 0; i < 4; i++) {
    finesseList.add(Finesse.finesseAdd(
        "Add Event unit test",
        "Description:" + new DateTime.now().toString(),
        null,
        "Activities and Recreation Center",
        "60 hours",
        type,
        new DateTime.now(),
        isActive: isActive));
  }
  return finesseList;
}

void createTestUser() async {
  LoginData data = new LoginData(email: CURRENT_USER_EMAIL, password: "123456");
  var res = await Network.createUser(data);
  if (res != null) {
    await Network.updateCurrentUser(email: CURRENT_USER_EMAIL);
  }
}

const VALID_EMAIL = 'test@test.com';
const CURRENT_USER_EMAIL = "test1@test.edu";
const VALID_PASSWORD = 'test123';
const INVALID_LOGIN_MSG = 'Username or password is incorrect.';
const TEST_EVENT_ID = '5e9fd7bbc318bf0017bf05a1';
final testFinesse = Finesse(TEST_EVENT_ID, 'title', 'desc', '', 'loc', 'duration', '', null, [], '', '');

Future<void> login(
    {String email: VALID_EMAIL,
    String password: VALID_PASSWORD,
    var expected}) async {
  LoginData data = LoginData(email: email, password: password);
  var actual = await Network.authUser(data);
  expect(actual, expected);
}

Future<void> signup({String email, String password, var expected}) async {
  LoginData data = LoginData(email: email, password: password);
  var actual = await Network.createUser(data);
  expect(actual, expected);
}

void validateEmail(String email, var expected) {
  var result = Network.validateEmail(email);
  expect(result, expected);
}

void validatePassword(String password, var expected) {
  var result = Network.validatePassword(password);
  expect(result, expected);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(
      {"typeFilter": false, "activeFilter": false});

//  createTestUser();

  test('Adding a new Finesse', () async {
    Finesse newFinesse = await addFinesseHelper('Adding a new Finesse');
    List<Finesse> finesseList = await Future.value(Network.fetchFinesses());
    expect(finesseList.last.getDescription(), newFinesse.getDescription());
    Network.removeFinesse(finesseList.last);
  });

  test('Removing a Finesse', () async {
    Finesse newFinesse = await addFinesseHelper('Removing a Finesse');

    Finesse secondNewFinesse = await addFinesseHelper('Removing a Finesse');

    await getAndRemove(secondNewFinesse); // Remove the first Finesse

    await getAndRemove(newFinesse);
  });

//  test('Removing a Finesse Exception', () async {
//    Finesse newFinesse = await addFinesseHelper('Removing a Finesse Exception');
//
//    newFinesse.setId("hello");
//
//    var exceptionText = "";
//    try {
//      await Network.removeFinesse(newFinesse); // Try Removing a Finesse without an ID
//    } on Exception catch (text) {
//      exceptionText = '$text';
//    }
//    expect(exceptionText, "Exception: Error while removing finesse");
//
//    //Cleanup
//    await getAndRemove(newFinesse);
//
//  });
//
//  test('Updating a Finesse Exception', () async {
//    Finesse newFinesse = await addFinesseHelper('Removing a Finesse Exception');
//
//    newFinesse.setId("hello");
//
//    var exceptionText = "";
//    try {
//      await Network.updateFinesse(newFinesse); // Try Removing a Finesse with a bad Id
//    } on Exception catch (text) {
//      exceptionText = '$text';
//    }
//    expect(exceptionText, "Exception: Error while updating finesse");
//
//    //Cleanup
//    await getAndRemove(newFinesse);
//
//  });

  test('Updating a Finesse', () async {
    Finesse firstNewFinesse = await addFinesseHelper('Updating a Finesse');

    List<Finesse> finesseList = await Future.value(Network.fetchFinesses());

    var now = new DateTime.now();
    String newDescription = "Description:" + now.toString();

    Finesse updatedFinesse = finesseList.last;
    updatedFinesse.setDescription(newDescription);

    await Network.updateFinesse(updatedFinesse);

    finesseList = await Future.value(Network.fetchFinesses());
    expect(finesseList.last.getDescription(),
        isNot(firstNewFinesse.getDescription()));
    expect(finesseList.last.getDescription(), updatedFinesse.getDescription());

    await Network.removeFinesse(finesseList.last);
  });

  test('applyFilters Test Other', () async {
    List<Finesse> finesseList = createFinesseList(type: "Other", isActive: []);
    List<Finesse> newList = await Network.applyFilters(finesseList);
    expect(newList.length, 0);
    expect(newList.length < finesseList.length, true);
  });

  test('applyFilters Test No Filter', () async {
    List<Finesse> finesseList = createFinesseList(type: "Food", isActive: []);
    List<Finesse> newList = await Network.applyFilters(finesseList);

    expect(newList.length, 4);
    expect(newList.length == finesseList.length, true);
  });

  test('applyFilters Test Inactive', () async {
    List<Finesse> finesseList = createFinesseList(
        type: "Food", isActive: ["username1", "username2", "username3"]);
    List<Finesse> newList = await Network.applyFilters(finesseList);
    expect(newList.length, 0);
    expect(newList.length < finesseList.length, true);
  });

  test('applyFilters Test Filters off', () async {
    SharedPreferences.setMockInitialValues(
        {"typeFilter": true, "activeFilter": true});

    List<Finesse> finesseList = createFinesseList(
        type: "Other", isActive: ["username1", "username2", "username3"]);
    List<Finesse> newList = await Network.applyFilters(finesseList);

    expect(newList.length, 4);
    expect(newList.length == finesseList.length, true);
  });

  test('Validate good email', () async {
    validateEmail('hello@world.edu', null);
  });

  test('Validate bad email', () async {
    validateEmail('Finesse', 'Invalid email address');
  });

  test('Validating empty email', () async {
    validateEmail('', 'Email can\'t be empty');
  });

  test('Validating good password', () async {
    validatePassword('longpassword', null);
  });

  test('Validating bad password', () async {
    validatePassword('short', 'Password must be at least 6 characters');
  });

  test('Validating empty password', () async {
    validatePassword('', 'Password must be at least 6 characters');
  });

  test('Correct Login', () async {
    await login(expected: null);
  });

  test('Incorrect Password', () async {
    await login(password: 'test1234', expected: INVALID_LOGIN_MSG);
  });

  test('Incorrect Email', () async {
    await login(email: 'test@test.org', expected: INVALID_LOGIN_MSG);
  });

  test('Incorrect Login', () async {
    await login(
        email: 'test@test.org',
        password: 'test1234',
        expected: INVALID_LOGIN_MSG);
  });

  test('Correct Signup', () async {
    String email =
        DateTime.now().millisecondsSinceEpoch.toString() + '@test.com';
    String password = VALID_PASSWORD;
    await signup(email: email, password: password, expected: null);
    await login(email: email, password: password, expected: null);
  });

  test('Incorrect Signup', () async {
    String email = VALID_EMAIL; // Already exists
    String password = VALID_PASSWORD;
    await signup(
        email: email, password: password, expected: 'User already exists');
  });

  test('Changing Notifications ON', () async {
    bool toggle = true;
    var result = await Network.changeNotifications(toggle);
    expect(result, null);
    expect(User.currentUser.notifications, toggle);
  });

  test('Changing Notifications OFF', () async {
    bool toggle = false;
    var result = await Network.changeNotifications(toggle);
    expect(result, null);
    expect(User.currentUser.notifications, toggle);
  });

  test('Getting Current User Data', () async {
    User.currentUser =
        User(CURRENT_USER_EMAIL, "none", "none", "none", 0, false);
    await Network.updateCurrentUser();
    expect(User.currentUser.points, 0);
    expect(User.currentUser.email, CURRENT_USER_EMAIL);
    expect(User.currentUser.password, isNot("none"));
  });

  test('Send Garbage to the Update Current User Function', () async {
    var exceptionText = "";
    try {
      await Network.updateCurrentUser(email: "asdfasefwef@esaasef.edu");
    } on Exception catch (text) {
      exceptionText = '$text';
    }
    expect(exceptionText, "Exception: Failed to get current user");
  });

  test('Send Push Notification', () async {
    var response =
        await Network.sendNotification('test', 'test', '-1', topic: 'tests');
    expect(response.statusCode, 200);
  });

  test('Add valid comment', () async {
    Comment comment =
        Comment('test comment', VALID_EMAIL, DateTime.now().toString());
    var response = await Network.addComment(comment, testFinesse);
    expect(response.statusCode, 200);
  });

  test('Add invalid comment', () async {
    Finesse invalid = Finesse('', 'title', 'desc', '', 'loc', 'duration', '', null, [], '', '');
    try {
      await Network.addComment(Comment('', '', ''), invalid);
    } catch (e) {
      String error = e.toString();
      expect(error.contains('Error while adding comment'), true);
      expect(error.contains('status = 400'), true);
      expect(error.contains('Please enter a valid email address'), true);
      expect(error.contains('The comment cannot be empty'), true);
      expect(error.contains('The time cannot be empty'), true);
      expect(error.contains('Please enter a valid event id'), true);
      return;
    }
    fail('Adding invalid comments should have thrown an exception');
  });

  test('Get Comments', () async {
    Comment testComment =
        Comment('test comment', VALID_EMAIL, DateTime.now().toString());
    await Network.addComment(testComment, testFinesse);
    List<Comment> comments = await Network.getComments(TEST_EVENT_ID);
    Comment last = comments.last;
    expect(last.comment, testComment.comment);
    expect(last.emailId, testComment.emailId);
    expect(last.postedTime, testComment.postedTime);
  });

  test('Get Invalid Comments', () async {
    List<Comment> result = await Network.getComments('no_comments');
    expect(result.length, 0);
  });
}

Future<List<Finesse>> getAndRemove(Finesse expectedFinesse) async {
  List<Finesse> finesseList = await Future.value(Network.fetchFinesses());

  expect(finesseList.last.getDescription(),
      expectedFinesse.getDescription()); // Check that it was added

  await Network.removeFinesse(finesseList.last); // Remove the first Finesse
  return finesseList;
}
