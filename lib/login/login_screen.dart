import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/home/home_page.dart';
import 'package:wibubarber/login/index.dart';
import 'package:wibubarber/login/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required LoginBloc loginBloc,
    Key? key,
  })  : loginBloc = loginBloc,
        super(key: key);

  final LoginBloc loginBloc;

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  LoginScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return BlocConsumer<LoginBloc, LoginState>(
        bloc: widget.loginBloc,
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.of(context).pushNamed(
              HomePage.routeName,
            );
          }
        },
        builder: (
          BuildContext context,
          LoginState currentState,
        ) {
          if (currentState is UnLoginState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorLoginState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    child: Text("Load lại"),
                    onPressed: () {
                      widget.loginBloc.add(LoadLoginEvent());
                    },
                  ),
                ),
              ],
            ));
          }
          if (currentState is InLoginState) {
            userNameController.text = "Admin";
            passwordController.text = "ditconmemay2";

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FlutterLogo(size: 160),
                    TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        labelText: "Tên đăng nhập hoặc Email",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    Row(
                      children: [],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (EmailValidator.validate(userNameController.text)) {
                          widget.loginBloc.add(
                            SignInEvent("", userNameController.text, passwordController.text),
                          );
                        } else {
                          widget.loginBloc.add(
                            SignInEvent(userNameController.text, "", passwordController.text),
                          );
                        }
                      },
                      child: Text("Đăng nhập"),
                    ),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Bạn chưa có tài khoản? ",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: "Đăng ký",
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SignUpScreen(loginBloc: widget.loginBloc),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget.loginBloc.add(LoadLoginEvent());
  }
}
