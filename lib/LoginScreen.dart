import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'main.dart';
import 'Network.dart';
import 'package:finesse_nation/User.dart';

class LoginScreen extends StatelessWidget {
  // Sign in callback
  Future<String> _authUser(LoginData data) async {
    User currUser = User.userAdd(data.name, data.password);
    var resp = await Network.loginUser(currUser);
    var status = resp[0], respBody = resp[1];
    if (status == 400) {
      return 'Username or password is incorrect.';
    }
    return null;
  }

  // Forgot Password callback
  Future<String> _recoverPassword(String name) async {
    // TODO
    return 'Password recovery feature not yet built. Try again later.';
  }

  // Sign up callback
  Future<String> _createUser(LoginData data) async {
    User newUser = User.userAdd(data.name, data.password);
    var resp = await Network.signupUser(newUser);
    var status = resp[0], respBody = json.decode(resp[1]);
    if (status == 400) {
      return respBody['msg'];
    }
    return null;
  }

  String _validateEmail(String email) {
    return email.isEmpty ? 'Email can\'t by empty' : null;
  }

  String _validatePassword(String password) {
    return password.length < 6 ? 'Password must be at least 6 characters' :
    null;
  }

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
      emailValidator: _validateEmail,
      passwordValidator: _validatePassword,
      onLogin: _authUser,
      onSignup: _createUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(title: 'Finesse Nation'),
        ));
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        recoverPasswordDescription: 'Email will be sent with link to reset '
            'password.'
      )
    );
  }
}
