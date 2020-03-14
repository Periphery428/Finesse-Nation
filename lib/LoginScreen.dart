import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'main.dart';
import 'Network.dart';

const users = const {
  'krastan@dimitrov.com': 'dimitrov',
  'RemFan69@gmail.com': 'iloverem',
  'marinov@illinois.edu': 'ovna1234',
  '': ''
};

class LoginScreen extends StatelessWidget {
  // Sign in callback
  Future<String> _authUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');
    if (!users.containsKey(data.name)) {
      return 'Username not found';
    }
    if (users[data.name] != data.password) {
      return 'Password does not match';
    }
    return null;
  }

  // Forgot Password callback
  Future<String> _recoverPassword(String name) async {
    print('Name: $name');
    if (!users.containsKey(name)) {
      return 'Username not exists';
    }
    return null;
  }

  // Sign up callback
  Future<String> _createUser(LoginData data) async {
    return null;
  }

  String _validateEmail(String email) {
    return null;
  }

  String _validatePassword(String password) {
    return null;
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
    );
  }
}
