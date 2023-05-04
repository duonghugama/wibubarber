import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/home/home_bloc.dart';
import 'package:wibubarber/home/home_page.dart';
import 'package:wibubarber/home/home_state.dart';
import 'package:wibubarber/login/index.dart';
import 'package:wibubarber/model/user_model.dart';
import 'package:wibubarber/style/index.dart';

import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc(InLoginState(null))),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc(InHomeState())),
        BlocProvider<StyleBloc>(create: (context) => StyleBloc(InStyleState(null))),
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
          themeMode: ThemeMode.dark,
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
    case StylePage.routeName:
      return MaterialPageRoute(
        builder: (context) => StylePage(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
  }
}
