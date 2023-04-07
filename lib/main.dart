import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/home/home_bloc.dart';
import 'package:wibubarber/home/home_page.dart';
import 'package:wibubarber/home/home_state.dart';
import 'package:wibubarber/login/index.dart';

import 'firebase_options.dart';

Future main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc(InLoginState())),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc(InHomeState())),
      ],
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        // if (state is LoginScreenState) {
        //   return MaterialApp(
        //     debugShowCheckedModeBanner: false,
        //     title: "WibuBarber",
        //     initialRoute: HomePage.routeName,
        //     onGenerateRoute: onGenerateRoute,
        //   );
        // }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "WibuBarber",
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute,
        );
      }),
    );
  }
}

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
    case HomePage.routeName:
      return MaterialPageRoute(
        builder: (context) => HomePage(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
  }
}
