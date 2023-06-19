import 'package:file_picker/file_picker.dart';
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
  final _loginBloc = LoginBloc(UnLoginState());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PlatformFile? pickedFile;
  DateTime? currentBackPressTime;
  String username = "";
  String name = "";
  List<String> roles = [];
  @override
  void initState() {
    super.initState();
    _loginBloc.add(LoadLoginEvent());
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

    Future selectFile() async {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          pickedFile = result.files.first;
        });
        _loginBloc.add(ChangeAvatarEvent(pickedFile));
      }
    }

    final ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
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
              setState(() {
                scaffoldKey.currentState?.openDrawer();
              });
            },
          ),
          title: Text('Home'),
          actions: [
            TextButton(
              onPressed: () {},
              style: buttonStyle,
              child: Text(
                "Chế độ thợ",
              ),
            )
          ],
        ),
        body: HomeScreen(homeBloc: _homeBloc),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.blue,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              children: <Widget>[
                // IconButton(
                //   tooltip: 'Favorite',
                //   icon: Icon(Icons.favorite),
                //   onPressed: () {},
                // ),
                // IconButton(
                //   tooltip: 'Lịch sử',
                //   icon: Icon(Icons.history),
                //   onPressed: () {},
                // ),
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
        drawer: BlocConsumer<LoginBloc, LoginState>(
          bloc: _loginBloc,
          listener: (context, state) {
            if (state is LogoutState) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(LoginPage.routeName, (Route<dynamic> route) => false);
            }
          },
          builder: (context, state) {
            if (state is InLoginState)
              return Drawer(
                child: Column(
                  children: [
                    DrawerHeader(
                      child: GestureDetector(
                        onTap: selectFile,
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: (state.user?.imageUrl ?? "") != ""
                              ? FadeInImage.assetNetwork(
                                  image: state.user!.imageUrl!,
                                  placeholder: 'lib/asset/loading-azurlane.gif',
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  'lib/asset/loading-azurlane.gif',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text("Người dùng: ${state.user?.name ?? ""}"),
                    ),
                    ListTile(
                      title: Text("Đăng ký làm thợ"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRScreen(
                              username: state.user?.username ?? "",
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
                        _loginBloc.add(LogoutEvent());
                      },
                    ),
                  ],
                ),
              );
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
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
      appBar: AppBar(),
      body: Center(
        child: QrImageView(data: "$username,$email"),
      ),
    );
  }
}
