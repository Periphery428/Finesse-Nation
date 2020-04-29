import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:finesse_nation/Util.dart';

Future<void> delay([int milliseconds = 250]) async {
  await Future<void>.delayed(Duration(milliseconds: milliseconds));
}

void main() {
  SharedPreferences.setMockInitialValues({});

//  test('Testing timestamp posting', () async {
////    await delay(3000);
//    var now = new DateTime.now();
//    String description = "Description:" + now.toString();
//    String title = "Testing time posted post and fetch";
//    Finesse newFinesse = Finesse.finesseAdd(
//        title,
//        description,
//        "",
//        "Activities and Recreation Center",
//        "60 hours",
//        "Food",
//        new DateTime.now());
//    await Network.addFinesse(newFinesse);
//    List<Finesse> finesseList = await Future.value(Network.fetchFinesses());
//    await delay(1000);
//    DateTime currTime = new DateTime.now();
//    Duration difference = currTime.difference(finesseList.last.getPostedTime());
//    expect(true, difference.inSeconds != 0);
////    expect(finesseList.last.getTitle(), title);
////    expect(finesseList.last.getDescription(), description);
//    await Network.removeFinesse(finesseList.last);
//  });

  test('Testing timeSince hours', () async {
    DateTime currTime = new DateTime.now();
    DateTime time1 = new DateTime(
        currTime.year, currTime.month, currTime.day, currTime.hour - 2);
    expect(true, Util.timeSince(time1) == "2 hours ago");
  });

  test('Testing timeSince minutes', () async {
    DateTime currTime = new DateTime.now();
    DateTime time1 = new DateTime(currTime.year, currTime.month, currTime.day,
        currTime.hour, currTime.minute - 5);
    expect(true, Util.timeSince(time1) == "5 minutes ago");
  });

  test('Testing timeSince seconds', () async {
    DateTime currTime = new DateTime.now();
    DateTime time1 = new DateTime(currTime.year, currTime.month, currTime.day,
        currTime.hour, currTime.minute, currTime.second - 10);
    expect(true, Util.timeSince(time1) != "1 minutes ago");
  });

  test('Testing timeSince 1 minute ago', () async {
    DateTime currTime = new DateTime.now();
    DateTime time1 = new DateTime(currTime.year, currTime.month, currTime.day,
        currTime.hour, currTime.minute-1, currTime.second);
    expect(Util.timeSince(time1), "1 minute ago");
  });

  test('Testing timeSince 1 hour ago', () async {
    DateTime currTime = new DateTime.now();
    DateTime time1 = new DateTime(currTime.year, currTime.month, currTime.day,
        currTime.hour-1, currTime.minute, currTime.second);
    expect(Util.timeSince(time1), "1 hour ago");
  });

  test('Testing timeSince 1 day ago', () async {
    DateTime currTime = new DateTime.now();
    DateTime time1 = new DateTime(currTime.year, currTime.month, currTime.day-1,
        currTime.hour, currTime.minute, currTime.second);
    expect(Util.timeSince(time1), "1 day ago");
  });

  test('Testing timeSince 2 days ago', () async {
    DateTime currTime = new DateTime.now();
    DateTime time1 = new DateTime(currTime.year, currTime.month, currTime.day-2,
        currTime.hour, currTime.minute, currTime.second);
    expect(Util.timeSince(time1), "2 days ago");
  });
}
