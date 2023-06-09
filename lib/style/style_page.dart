import 'package:flutter/material.dart';
import 'package:vertical_tab_bar_view/vertical_tab_bar_view.dart';
import 'package:wibubarber/style/add_style_screen.dart';
import 'package:wibubarber/style/index.dart';

class StylePage extends StatefulWidget {
  static const String routeName = '/style';

  @override
  _StylePageState createState() => _StylePageState();
}

class _StylePageState extends State<StylePage> {
  final _styleBloc = StyleBloc(UnStyleState());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddStyleScreen()));
          },
        ),
      ),
    );
  }
}
