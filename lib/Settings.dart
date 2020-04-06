import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:camera/camera.dart';
import 'package:finesse_nation/main.dart';
import 'package:finesse_nation/cameraPage.dart';
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

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  var toggle = false;

  @override
  SettingsPageState createState() {
    return SettingsPageState();
  }

  @override
  void dispose() {
    if (toggle) {
      FirebaseMessaging().subscribeToTopic('all');
    } else {
      FirebaseMessaging().unsubscribeFromTopic('all');
    }
    print("Send Opt out request");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10, bottom: 10),
          child: Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ]),
      Column(children: <Widget>[
        CustomSwitch(
            key: Key("Not Toggle"),
            activeColor: Color(0xffff9900),
            value: toggle,
            onChanged: (value) {
              toggle = !toggle;
            })
      ]),
    ]);
  }
}
