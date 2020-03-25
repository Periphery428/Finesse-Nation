import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'main.dart';
import 'Network.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        title: null,
        logo: 'images/logo.png',
        theme: LoginTheme(
            primaryColor: Colors.black,
            accentColor: Colors.black,
            cardTheme: CardTheme(color: Color(0xffff9900)),
            buttonTheme: LoginButtonTheme(
              splashColor: Colors.grey[800],
            )
//        pageColorLight: Colors.lightblue,
//        pageColorDark: Colors.pink,
            ),
        emailValidator: Network.validateEmail,
        passwordValidator: Network.validatePassword,
        onLogin: Network.authUser,
        onSignup: Network.createUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'Finesse Nation'),
          ));
        },
        onRecoverPassword: Network.recoverPassword,
        messages: LoginMessages(
            recoverPasswordDescription:
                'Email will be sent with a link to reset your password.'));
  }
}
