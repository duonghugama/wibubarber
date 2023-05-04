import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Style'),
      ),
      body: StyleScreen(styleBloc: _styleBloc),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddStyleScreen()));
        },
      ),
    );
  }
}
