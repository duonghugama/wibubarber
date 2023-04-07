import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/home/home_page.dart';
import 'package:wibubarber/login/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required LoginBloc loginBloc,
    Key? key,
  })  : _loginBloc = loginBloc,
        super(key: key);

  final LoginBloc _loginBloc;

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
        bloc: widget._loginBloc,
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.of(context).pushNamed(HomePage.routeName);
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
                      widget._loginBloc.add(LoadLoginEvent());
                    },
                  ),
                ),
              ],
            ));
          }
          if (currentState is InLoginState) {
            userNameController.text = "duonghugama3@gmail.com";
            passwordController.text = "ditconmemay2";
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlutterLogo(size: 160),
                    TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        labelText: "Tên đăng nhập hoặc Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        widget._loginBloc.add(SignInEvent(userNameController.text, passwordController.text));
                      },
                      icon: Icon(Icons.person),
                      label: Text("Đăng nhập"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.person_add),
                      label: Text("Đăng ký"),
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
    widget._loginBloc.add(LoadLoginEvent());
  }
}
