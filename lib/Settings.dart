import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/User.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'User.dart';
import 'LoginScreen.dart';

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
  var toggle = User.currentUser.notifications;

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
    Network.changeNotifications(toggle);

    print("Send Opt out request");
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
                          activeColor: Color(0xffff9900),
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
                        color: Color(0xffFF9900),
                        child: Text(
                          'LOGOUT',
                          style: TextStyle(color: Colors.grey[850]),
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
