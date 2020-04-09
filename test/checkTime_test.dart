import 'dart:async';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/widgets/buildFinesseCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_test/flutter_test.dart';
import 'package:test/test.dart';

Future<void> delay([int milliseconds = 250]) async {
  await Future<void>.delayed(Duration(milliseconds: milliseconds));
}

void main() {
  SharedPreferences.setMockInitialValues({});

  test('Testing time posted post and fetch', () async {
    var now = new DateTime.now();
    Finesse newFinesse = Finesse.finesseAdd(
        "Testing time posted post and fetch",
        "Description:" + now.toString(),
        "",
        "Activities and Recreation Center",
        "60 hours",
        "Food",
        new DateTime.now());
    await Network.addFinesse(newFinesse);
    List<Finesse> finesseList = await Future.value(Network.fetchFinesses());
    await delay((1000));
    DateTime currTime = new DateTime.now();
    Duration difference = currTime.difference(finesseList.last.getPostedTime());
    expect(true, difference.inSeconds != 0);
    await Network.removeFinesse(finesseList.last);
    await Network.removeFinesse(finesseList.last);
  });

  test('Testing timeSince hours', () async {
    DateTime currTime = new DateTime.now();
    DateTime time1 = new DateTime(
        currTime.year, currTime.month, currTime.day, currTime.hour - 2);
    expect(true, timeSince(time1) == "2 hours ago");
  });

  test('Testing timeSince minutes', () async {
    DateTime currTime = new DateTime.now();
    DateTime time1 = new DateTime(currTime.year, currTime.month, currTime.day,
        currTime.hour, currTime.minute - 5);
    expect(true, timeSince(time1) == "5 minutes ago");
  });

  test('Testing timeSince seconds', () async {
    DateTime currTime = new DateTime.now();
    DateTime time1 = new DateTime(currTime.year, currTime.month, currTime.day,
        currTime.hour, currTime.minute, currTime.second - 10);
    expect(true, timeSince(time1) != "1 minutes ago");
  });
}
