import 'package:flutter/material.dart';

import 'package:finesse_nation/login/flutter_login.dart';
import 'package:finesse_nation/Pages/main.dart';
import 'package:finesse_nation/Network.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:finesse_nation/Styles.dart';

class LoginScreen extends StatelessWidget {
  changeStatusColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
      if (useWhiteForeground(color)) {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
//        _useWhiteStatusBarForeground = true;
//        _useWhiteNavigationBarForeground = true;
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
//        _useWhiteStatusBarForeground = false;
//        _useWhiteNavigationBarForeground = false;
      }
    } catch (e) {
      debugPrint('COLORZZ' + e.toString());
    }
  }

  changeNavigationColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setNavigationBarColor(color, animate: true);
    } catch (e) {
      debugPrint('COLORZZ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.black);
    changeNavigationColor(Colors.black);
    return FlutterLogin(
      title: null,
      logo: 'images/logo.png',
      theme: LoginTheme(
          primaryColor: Colors.black,
          accentColor: Colors.black,
          cardTheme: CardTheme(color: Styles.brightOrange),
          buttonTheme: LoginButtonTheme(
            splashColor: Colors.grey[800],
          )
//        pageColorLight: Colors.lightblue,
//        pageColorDark: Colors.pink,
          ),
      emailValidator: /*(_) => null  ,// */ Network.validateEmail,
      passwordValidator: /*(_) => null  ,// */ Network.validatePassword,
      onLogin: /*(_) => null  ,// */ Network.authUser,
      onSignup: /*(_) => null  ,// */ Network.createUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ));
      },
      onRecoverPassword: Network.recoverPassword,
      logoTag: 'logo',
      messages: LoginMessages(
          recoverPasswordDescription:
              'Email will be sent with a link to reset your password.'),
    );
  }
}
