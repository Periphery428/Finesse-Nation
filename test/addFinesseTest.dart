// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:test/test.dart';
import 'package:finesse_nation/finesse.dart';
import 'package:finesse_nation/finesseList.dart';

void main() {
  test('Adding a new Finesse', () {
    FinesseList finesses = FinesseList();
    Finesse finesse =
        Finesse("Free food here", "Good Pizza", "Second floor Arc", "Food", "60 hours");
    finesses.addFinesse(finesse); //This call adds a finesse to the DB
    List finesses_list =
        finesses.getFinesses(); //This call gets finesses from DB

    expect(finesses_list.first.getTitle(), finesse.getTitle());
  });
}
