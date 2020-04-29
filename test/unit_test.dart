import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/User.dart';
import 'package:finesse_nation/Util.dart';
import 'package:finesse_nation/Comment.dart';

import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(
      {"typeFilter": false, "activeFilter": false});

  test('Get UserName test', () {
    User testUser = User(
        "this._email", "this._password", "UserName", "this._school", 0, false);
    expect(testUser.userName, "UserName");
  });

  test('setId', () {
    Finesse newFinesse = Finesse.finesseAdd(
        "setId unit test",
        "Description:",
        null,
        "Activities and Recreation Center",
        "60 hours",
        "Food",
        new DateTime.now());
    expect(newFinesse.getId(), null);
    newFinesse.setId("12323413512341234");
    expect(newFinesse.getId(), "12323413512341234");
  });

  test('setActive', () {
    Finesse newFinesse = Finesse.finesseAdd(
        "setId unit test",
        "Description:",
        null,
        "Activities and Recreation Center",
        "60 hours",
        "Food",
        new DateTime.now());
    expect(newFinesse.getActive(), null);
    List activeList = ["person1", "person2"];
    newFinesse.setActive(activeList);
    expect(newFinesse.getActive(), activeList);
  });

  test('parse Exception', () {
    DateTime parsedTime = Finesse.parse("Invalid Time");
    expect(Util.timeSince(parsedTime), 'now');
  });

  test('parse null', () {
    DateTime parsedTime = Finesse.parse(null);
    expect(Util.timeSince(parsedTime), 'now');
  });

  test('Comment datetime', () {
    String now = DateTime.now().toString();
    Comment comment = Comment("comment", "emailId", now);
    expect(comment.postedDateTime, DateTime.parse(now));
  });

  test('Comment post', () {
    String commentStr = "I like this comment";
    Comment comment = Comment.post(commentStr);
    expect(comment.comment, commentStr);
  });
}
