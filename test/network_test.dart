// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:async';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Network.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

Future<Finesse> addFinesseHelper([name]) async {
  var now = new DateTime.now();
  Finesse newFinesse = Finesse.finesseAdd(
      name ?? "Add Event unit test",
      "Description:" + now.toString(),
      null,
      "Second floor Arc",
      "60 hours",
      "FOOD",
      new DateTime.now());
  await Network.addFinesse(newFinesse);
  return newFinesse;
}

List<Finesse> createFinesseList({String type = "FOOD", bool isActive = true}) {
  List<Finesse> finesseList = [];

  for (var i = 0; i < 4; i++) {
    finesseList.add(Finesse.finesseAdd(
        "Add Event unit test",
        "Description:" + new DateTime.now().toString(),
        null,
        "Second floor Arc",
        "60 hours",
        type,
        new DateTime.now(),
        isActive: isActive));
  }
  return finesseList;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(
      {"typeFilter": false, "activeFilter": false});

  test('Adding a new Finesse', () async {
    Finesse newFinesse = await addFinesseHelper('Adding a new Finesse');
    List<Finesse> finesseList = await Future.value(Network.fetchFinesses());
    expect(finesseList.last.getDescription(), newFinesse.getDescription());
    Network.removeFinesse(finesseList.last);
  });

  test('Removing a Finesse', () async {
    Finesse newFinesse = await addFinesseHelper('Removing a Finesse');

    Finesse secondNewFinesse = await addFinesseHelper('Removing a Finesse');

    List<Finesse> finesseList = await Future.value(Network.fetchFinesses());

    expect(finesseList.last.getDescription(),
        secondNewFinesse.getDescription()); // Check that it was added

    await Network.removeFinesse(finesseList.last); // Remove the first Finesse

    finesseList = await Future.value(Network.fetchFinesses());

    expect(
        finesseList.last.getDescription(),
        newFinesse
            .getDescription()); // Check to make sure the new event was actually removed

    await Network.removeFinesse(finesseList.last);
  });

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
    List<Finesse> finesseList =
        createFinesseList(type: "OTHER", isActive: true);
    List<Finesse> newList = await Network.applyFilters(finesseList);
    print(newList.length + finesseList.length);

    expect(newList.length, 0);
    expect(newList.length < finesseList.length, true);
  });

  test('applyFilters Test No Filter', () async {
    List<Finesse> finesseList = createFinesseList(type: "FOOD", isActive: true);
    List<Finesse> newList = await Network.applyFilters(finesseList);

    expect(newList.length, 4);
    expect(newList.length == finesseList.length, true);
  });

  test('applyFilters Test Inactive', () async {
    List<Finesse> finesseList =
        createFinesseList(type: "FOOD", isActive: false);
    List<Finesse> newList = await Network.applyFilters(finesseList);

    expect(newList.length, 0);
    expect(newList.length < finesseList.length, true);
  });

  test('applyFilters Test Filters off', () async {
    SharedPreferences.setMockInitialValues(
        {"typeFilter": true, "activeFilter": true});

    List<Finesse> finesseList =
        createFinesseList(type: "OTHER", isActive: false);
    List<Finesse> newList = await Network.applyFilters(finesseList);

    expect(newList.length, 4);
    expect(newList.length == finesseList.length, true);
  });

  test('Validate bad email', () async {
    var failEmail = 'Invalid email address';

    String badEmail = 'Finesse';
    var result = Network.validateEmail(badEmail);
    expect(result, equals(failEmail));
  });

  test('Validate good email', () async {
    String goodEmail = 'hello@world.com';
    var result = Network.validateEmail(goodEmail);
    expect(result, equals(null));

    String goodEmail2 = 'email234test@testemail.com';
    result = Network.validateEmail(goodEmail2);
    expect(result, equals(null));
  });

  test('Validating empty email', () async {
    var failEmail = 'Email can\'t be empty';

    String badEmail = '';
    var result = Network.validateEmail(badEmail);
    expect(result, equals(failEmail));
  });

  test('Validating password', () async {
    var failPassword = 'Password must be at least 6 characters';

    String badPassword = 'short';
    var result = Network.validatePassword(badPassword);
    expect(result, equals(failPassword));

    String goodPassword = 'longer';
    result = Network.validatePassword(goodPassword);
    expect(result, equals(null));
  });
}
