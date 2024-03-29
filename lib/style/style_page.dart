import 'package:flutter/material.dart';
import 'package:wibubarber/login/login_event.dart';
import 'package:wibubarber/style/index.dart';

class StylePage extends StatefulWidget {
  static const String routeName = '/style';

  @override
  _StylePageState createState() => _StylePageState();
}

class _StylePageState extends State<StylePage> {
  final _styleBloc = StyleBloc(UnStyleState());
  int index = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Stack(
        children: [
          Image.asset(
            "lib/asset/background/background1.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
                SliverAppBar(
                  title: Text('Dịch vụ'),
                  floating: true,
                  pinned: true,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        text: "Kiểu tóc",
                      ),
                      Tab(
                        text: "Màu tóc",
                      ),
                    ],
                    onTap: (value) {
                      setState(() {
                        index = value;
                      });
                    },
                  ),
                ),
              ],
              body: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: TabBarView(
                  children: [
                    StyleScreen(styleBloc: _styleBloc),
                    ColorScreen(styleBloc: _styleBloc),
                  ],
                ),
              ),
            ),
            floatingActionButton: LoginEvent.permission.contains("Admin")
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      if (index == 0)
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => StyleDetailScreen()));
                      else
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Chưa có tính năng này")));
                    },
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
