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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc(InLoginState(null))),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc(InHomeState(null, null, null, null))),
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
          theme: ThemeData(
            brightness: Brightness.light,
            appBarTheme: AppBarTheme(
              color: Colors.white54,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            iconTheme: IconThemeData(color: Color.fromARGB(255, 101, 204, 176)),
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.cyan)),
            ),
            primaryColor: Color.fromARGB(255, 101, 204, 176),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color.fromARGB(255, 101, 204, 176),
            ),
            tabBarTheme: TabBarTheme(
              labelColor: Colors.white,
              labelStyle: TextStyle(color: Colors.white),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color.fromARGB(255, 101, 204, 176), width: 10),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              floatingLabelStyle: TextStyle(color: Colors.white),
              focusColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              filled: true,
              fillColor: Colors.white60,
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              // ),
              // labelStyle: TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            chipTheme: ChipThemeData(backgroundColor: Colors.white70),
            dropdownMenuTheme: DropdownMenuThemeData(
              inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white, filled: true),
              menuStyle: MenuStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.white,
                ),
              ),
            ),
            canvasColor: Colors.transparent,
            fontFamily: 'Anime',
          ),
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
