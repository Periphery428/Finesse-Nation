// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:async';
import 'package:test/test.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/FinesseList.dart';

void main() {
  test('Adding a new Finesse', () async {
    Finesse newFinesse = Finesse("Add Event unit test", "Good Pizza", "",
        "Second floor Arc", "60 hours", "Food");
    await newFinesse.addFinesse(); //This call adds a finesse to the DB
    List<Finesse> finesseList = await Future.value(FinesseList.fetchFinesses());
    expect(finesseList.last.getTitle(), newFinesse.getTitle());
    newFinesse.removeFinesse();
  });
}
