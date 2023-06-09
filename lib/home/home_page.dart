import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wibubarber/barber/barber_page.dart';
import 'package:wibubarber/home/index.dart';
import 'package:wibubarber/login/index.dart';
import 'package:wibubarber/schedule/index.dart';
import 'package:wibubarber/style/index.dart';
import 'package:wibubarber/userlocalstorage.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeBloc = HomeBloc(UnHomeState());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? currentBackPressTime;
  String username = "";
  String name = "";
  List<String> roles = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserData();
    });
  }

  getUserData() async {
    String u = await UserLocalStorage.getUsername();
    String n = await UserLocalStorage.getname();
    List<String> r = await UserLocalStorage.getRoles();
    setState(() {
      username = u;
      name = n;
      roles = r;
    });
  }

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

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogoutState) {
          Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.routeName, (Route<dynamic> route) => false);
        }
      },
      builder: (context, state) {
        if (state is InLoginState)
          return WillPopScope(
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
                        onPressed: () {},
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
                      leading: FlutterLogo(size: 20),
                      title: Text(name),
                    ),
                    ListTile(
                      title: Text("Đăng ký làm thợ"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRScreen(
                              username: username,
                              email: FirebaseAuth.instance.currentUser?.email.toString() ?? "",
                            ),
                          ),
                        );
                      },
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
          );
        return Center(
          child: Text("Lỗi State"),
        );
      },
    );
  }
}

class QRScreen extends StatelessWidget {
  final String username;
  final String email;

  const QRScreen({super.key, required this.email, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: QrImage(data: "$username, $email"),
      ),
    );
  }
}
