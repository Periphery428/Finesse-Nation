import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:finesse_nation/Util.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  test('Testing timeSince hours', () async {
    checkTime("2 hours ago", hour: 2);
  });

  test('Testing timeSince minutes', () async {
    checkTime("5 minutes ago", minute: 5);
  });

  test('Testing timeSince seconds', () async {
    checkTime("now", second: 10);
  });

  test('Testing timeSince 1 minute ago', () async {
    checkTime("1 minute ago", minute: 1);
  });

  test('Testing timeSince 1 hour ago', () async {
    checkTime("1 hour ago", hour: 1);
  });

  test('Testing timeSince 1 day ago', () async {
    checkTime("1 day ago", day: 1);
  });

  test('Testing timeSince 2 days ago', () async {
    checkTime("2 days ago", day: 2);
  });
}

///Function contains parameterized values to remove a certain amount of time from the current time and check the expected text against it
void checkTime(String expected,
    {int year = 0,
    int month = 0,
    int day = 0,
    int hour = 0,
    int minute = 0,
    int second = 0}) {
  DateTime currTime = DateTime.now();
  DateTime time1 = DateTime(
      currTime.year - year,
      currTime.month - month,
      currTime.day - day,
      currTime.hour - hour,
      currTime.minute - minute,
      currTime.second - second);
  expect(Util.timeSince(time1), expected);
}
