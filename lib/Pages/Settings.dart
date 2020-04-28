import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/User.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:finesse_nation/Pages/LoginScreen.dart';
import 'package:finesse_nation/Styles.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Settings';

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      backgroundColor: Styles.darkGrey,
      body: SettingsPage(),
    );
  }
}

class Notifications {
  static Future<void> notificationsSet(toggle) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    if (User.currentUser.email.contains('@test.com') ||
        User.currentUser.email.contains('@test.edu')) {
      return;
    }
    if (toggle) {
      _firebaseMessaging.subscribeToTopic('all');
    } else {
      _firebaseMessaging.unsubscribeFromTopic('all');
    }
    await Network.changeNotifications(toggle);
  }
}

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  var initialToggle = User.currentUser.notifications;
  var toggle = User.currentUser.notifications;

  SettingsPageState createState() {
    return SettingsPageState();
  }

  @override
  void dispose() {
    if (toggle != initialToggle) {
      Notifications.notificationsSet(toggle);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(right: 15, bottom: 10, top: 10, left: 10),
              child: Text(
                'Notifications',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right: 15, bottom: 10, top: 10, left: 10),
                      child: CustomSwitch(
                          key: Key("Notification Toggle"),
                          activeColor: Styles.brightOrange,
                          value: toggle,
                          onChanged: (value) {
                            toggle = !toggle;
                          }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        Divider(color: Colors.black),
        Row(
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(right: 15, bottom: 10, top: 10, left: 10),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Account',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      User.currentUser.email,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                )),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right: 15, bottom: 10, top: 10, left: 10),
                      child: RaisedButton(
                        key: Key('logoutButton'),
                        color: Styles.brightOrange,
                        child: Text(
                          'LOGOUT',
                          style: TextStyle(color: Styles.darkGrey),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        Divider(color: Colors.black),
      ],
    );
  }
}
