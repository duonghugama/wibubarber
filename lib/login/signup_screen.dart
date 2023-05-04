import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/login/index.dart';

import 'login_bloc.dart';

class SignUpScreen extends StatefulWidget {
  final LoginBloc _loginBloc;

  const SignUpScreen({super.key, required LoginBloc loginBloc}) : _loginBloc = loginBloc;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is CreateUserSuccessState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Đăng ký"),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FlutterLogo(size: 160),
                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    labelText: "Tên đăng nhập",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  ),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  ),
                  keyboardType: TextInputType.emailAddress,
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
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => SignUpScreen(loginBloc: widget._loginBloc),
                    //   ),
                    // );
                    BlocProvider.of<LoginBloc>(context)
                        .add(SignUpEvent(userNameController.text, emailController.text, passwordController.text));
                  },
                  icon: Icon(Icons.person_add),
                  label: Text("Đăng ký"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
