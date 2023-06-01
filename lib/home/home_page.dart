import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wibubarber/barber/barber_page.dart';
import 'package:wibubarber/home/index.dart';
import 'package:wibubarber/login/index.dart';
import 'package:wibubarber/schedule/index.dart';
import 'package:wibubarber/style/index.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeBloc = HomeBloc(UnHomeState());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(
          msg: "Ấn lần nữa để thoát",
          gravity: ToastGravity.BOTTOM_RIGHT,
        );
        return Future.value(false);
      }
      SystemNavigator.pop();
      return Future.value(true);
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogoutState) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              tooltip: 'Menu',
              icon: Icon(Icons.menu),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
            ),
            title: Text('Home'),
          ),
          body: HomeScreen(homeBloc: _homeBloc),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Colors.blue,
            child: IconTheme(
              data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              child: Row(
                children: <Widget>[
                  IconButton(
                    tooltip: 'Favorite',
                    icon: Icon(Icons.favorite),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: 'Lịch sử',
                    icon: Icon(Icons.history),
                    onPressed: () {
                      // FirebaseDatabase database = FirebaseDatabase.instance;
                      // if (kDebugMode) {
                      //   print(database.app.options.databaseURL);
                      // }
                      // _homeBloc.add(LoadStyleEventTest());
                    },
                  ),
                  Spacer(),
                  IconButton(
                    tooltip: 'Barber',
                    icon: Image.asset("lib/asset/barber.png", color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pushNamed(BarberPage.routeName);
                    },
                  ),
                  IconButton(
                    tooltip: 'Kiểu tóc',
                    icon: Image.asset("lib/asset/razor.png", color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pushNamed(StylePage.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(FontAwesome5.calendar_check),
            onPressed: () {
              Navigator.of(context).pushNamed(SchedulePage.routeName);
            },
          ),
          drawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  child: FlutterLogo(size: 50),
                ),
                ListTile(
                  leading: FlutterLogo(),
                  onTap: () {},
                ),
                Spacer(),
                ListTile(
                  title: Text("Đăng xuất"),
                  onTap: () {
                    BlocProvider.of<LoginBloc>(context).add(LogoutEvent());
                  },
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
