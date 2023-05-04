import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:wibubarber/home/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required HomeBloc homeBloc,
    Key? key,
  })  : _homeBloc = homeBloc,
        super(key: key);

  final HomeBloc _homeBloc;

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: widget._homeBloc,
      builder: (
        BuildContext context,
        HomeState currentState,
      ) {
        if (currentState is UnHomeState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (currentState is ErrorHomeState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    onPressed: _load,
                    child: Text('reload'),
                  ),
                ),
              ],
            ),
          );
        }
        if (currentState is InHomeState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  children: [
                    RawMaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [Icon(FontAwesome5.calendar_check), Text("Đặt lịch")],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [Icon(FontAwesome5.history), Text("Lịch sử")],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [Icon(FontAwesome5.list_alt), Text("Bảng giá")],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [Icon(FontAwesome5.tags), Text("Ưu đãi")],
                        ),
                      ),
                    ),
                    // RawMaterialButton(
                    //   shape: CircleBorder(),
                    //   onPressed: () {},
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10),
                    //     child: Column(
                    //       children: [Icon(Typicons.scissors), Text("Bí kíp")],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[100],
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _load() {
    widget._homeBloc.add(LoadHomeEvent());
  }
}
