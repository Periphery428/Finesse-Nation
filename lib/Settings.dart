import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:camera/camera.dart';
import 'package:finesse_nation/main.dart';
import 'package:finesse_nation/User.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Settings';

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      backgroundColor: Colors.grey[850],
      body: SettingsPage(),
    );
  }
}

class Notifications {
  static notificationsSet(toggle) {
    if (toggle) {
      FirebaseMessaging().subscribeToTopic('all');
    } else {
      FirebaseMessaging().unsubscribeFromTopic('all');
    }
    Network.changeNotifications(toggle);
  }
}

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  var toggle = User.currentUser.notifications;

  @override
  SettingsPageState createState() {
    return SettingsPageState();
  }

  @override
  void dispose() {
    Notifications.notificationsSet(toggle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15, bottom: 10, top: 10, left: 10),
          child: Text(
            'Notifications',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        new Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(right: 15, bottom: 10, top: 10, left: 10),
                child: CustomSwitch(
                    key: Key("Notification Toggle"),
                    activeColor: Color(0xffff9900),
                    value: toggle,
                    onChanged: (value) {
                      toggle = !toggle;
                    }),
              ),
            ]),
          ),
        )
      ]),
      Expanded(
        child: Column(
          children: <Widget>[Divider(color: Colors.black)],
        ),
      )
    ]);
  }
}
