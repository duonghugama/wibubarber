import 'package:flutter/material.dart';
import 'package:wibubarber/schedule/index.dart';

class SchedulePage extends StatefulWidget {
  static const String routeName = '/schedule';

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _scheduleBloc = ScheduleBloc(UnScheduleState());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "lib/asset/background/background.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Đặt lịch"),
          ),
          body: ScheduleScreen(scheduleBloc: _scheduleBloc),
        ),
      ],
    );
  }
}
