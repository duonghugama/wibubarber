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
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
    return BlocConsumer<LoginBloc, LoginState>(
        bloc: widget.loginBloc,
        listener: (context, state) {
          if (state is LoginSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Đăng nhập thành công!"),
              action: SnackBarAction(
                  label: "Đóng",
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }),
            ));
            Navigator.of(context).pushNamed(
              HomePage.routeName,
            );
          }
          if (state is LoginFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Sai tên đăng nhập hoặc mật khẩu!"),
              action: SnackBarAction(
                  label: "Đóng",
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }),
            ));
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
              ),
            );
          }
          if (currentState is InLoginState) {
            // userNameController.text = "Admin";
            // passwordController.text = "ditconmemay2";

            return Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("lib/asset/Logo1.png"),
                      TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          labelText: "Tên đăng nhập hoặc Email",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          filled: true,
                          fillColor: Colors.white38,
                        ),
                        style: TextStyle(),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nhập tên đăng nhập';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          filled: true,
                          fillColor: Colors.white38,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nhập mật khẩu';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (EmailValidator.validate(userNameController.text)) {
                              widget.loginBloc.add(
                                SignInEvent("", userNameController.text, passwordController.text),
                              );
                            } else {
                              widget.loginBloc.add(
                                SignInEvent(userNameController.text, "", passwordController.text),
                              );
                            }
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
