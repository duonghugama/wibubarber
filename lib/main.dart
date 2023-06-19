import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/barber/barber_bloc.dart';
import 'package:wibubarber/barber/barber_page.dart';
import 'package:wibubarber/barber/barber_state.dart';
import 'package:wibubarber/home/home_bloc.dart';
import 'package:wibubarber/home/home_page.dart';
import 'package:wibubarber/home/home_state.dart';
import 'package:wibubarber/login/index.dart';
import 'package:wibubarber/schedule/index.dart';
import 'package:wibubarber/style/index.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate(
  //   webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  //   androidProvider: AndroidProvider.debug,
  // );
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
        BlocProvider<StyleBloc>(create: (context) => StyleBloc(InStyleState(null, null))),
        BlocProvider<BarberBloc>(create: (context) => BarberBloc(InBarberState([]))),
        BlocProvider<ScheduleBloc>(create: (context) => ScheduleBloc(InScheduleState("", "", null, []))),
      ],
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "WibuBarber",
          initialRoute: LoginPage.routeName,
          onGenerateRoute: onGenerateRoute,
          themeMode: ThemeMode.dark,
          // theme: ThemeData(fontFamily: 'Anime'),
        );
      }),
    );
  }
}

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginPage.routeName:
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
    case BarberPage.routeName:
      return MaterialPageRoute(
        builder: (context) => BarberPage(),
      );
    case SchedulePage.routeName:
      return MaterialPageRoute(
        builder: (context) => SchedulePage(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
  }
}
