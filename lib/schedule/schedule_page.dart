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
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      body: ScheduleScreen(scheduleBloc: _scheduleBloc),
    );
  }
}
