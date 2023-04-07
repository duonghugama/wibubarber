import 'package:flutter/material.dart';
import 'package:wibubarber/login/index.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginBloc = LoginBloc(UnLoginState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreen(loginBloc: _loginBloc),
    );
  }
}
