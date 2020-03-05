// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:async';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Network.dart';
import 'package:test/test.dart';

void main() {
  test('Adding a new Finesse', () async {
    var now = new DateTime.now();
    Finesse newFinesse = Finesse.finesseAdd("Add Event unit test", now.toString(), "",
        "Second floor Arc", "60 hours", "Food", new DateTime.now());
    await Network.addFinesse(newFinesse);
    List<Finesse> finesseList = await Future.value(Network.fetchFinesses());
    expect(finesseList.last.getTitle(), newFinesse.getTitle());
    Network.removeFinesse(newFinesse);
  });

//  test('Removing a Finesse', () async {
//    Finesse newFinesse = Finesse("Add Event unit test1", "Good Pizza", "",
//        "Second floor Arc", "60 hours", "Food");
//    await Network.addFinesse(newFinesse); //This call adds a finesse to the DB
//
//    Finesse secondNewFinesse = Finesse("Add Event unit test2", "Good Pizza", "",
//        "Second floor Arc", "60 hours", "Food");
//    await Network.addFinesse(
//        secondNewFinesse); //This call adds a finesse to the DB
//
//    List<Finesse> finesseList = await Future.value(Network.fetchFinesses());
//    expect(finesseList.last.getTitle(),
//        secondNewFinesse.getTitle()); // Check that it was added
//
//    Network.removeFinesse(secondNewFinesse); // Remove the first Finesse
//
//    finesseList = await Future.value(Network.fetchFinesses());
//    expect(
//        finesseList.last.getTitle(),
//        newFinesse
//            .getTitle()); // Check to make sure the new event was actually removed
//    Network.removeFinesse(newFinesse);
//  });
}
