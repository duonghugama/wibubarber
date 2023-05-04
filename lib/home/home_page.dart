import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:wibubarber/home/index.dart';
import 'package:wibubarber/login/index.dart';
import 'package:wibubarber/style/index.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeBloc = HomeBloc(UnHomeState());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: FlutterLogo(size: 50),
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
                tooltip: 'Menu',
                icon: Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
              IconButton(
                tooltip: 'Favorite',
                icon: const Icon(Icons.favorite),
                onPressed: () {},
              ),
              IconButton(
                tooltip: 'Lịch sử',
                icon: const Icon(Icons.history),
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
                tooltip: 'Kiểu tóc',
                icon: Image.asset("lib/asset/barber.png", color: Colors.white),
                // icon: SvgPicture.asset("lib/asset/razor.svg"),
                onPressed: () {
                  Navigator.of(context).pushNamed(StylePage.routeName);
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
        onPressed: () {},
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
    );
  }
}
