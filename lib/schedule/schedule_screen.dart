import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/schedule/index.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({
    required ScheduleBloc scheduleBloc,
    Key? key,
  })  : _scheduleBloc = scheduleBloc,
        super(key: key);

  final ScheduleBloc _scheduleBloc;

  @override
  ScheduleScreenState createState() {
    return ScheduleScreenState();
  }
}

class ScheduleScreenState extends State<ScheduleScreen> {
  ScheduleScreenState();
  int _index = 0;
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
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      bloc: widget._scheduleBloc,
      builder: (
        BuildContext context,
        ScheduleState currentState,
      ) {
        if (currentState is UnScheduleState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (currentState is ErrorScheduleState) {
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
          ));
        }
        if (currentState is InScheduleState) {
          return Stepper(
            currentStep: _index,
            onStepCancel: () {
              if (_index > 0) {
                setState(() {
                  _index -= 1;
                });
              }
            },
            onStepContinue: () {
              if (_index <= 0) {
                setState(() {
                  _index += 1;
                });
              }
            },
            onStepTapped: (int index) {
              setState(() {
                _index = index;
              });
            },
            steps: [
              Step(
                title: Text("Chọn gói dịch vụ"),
                content: GestureDetector(
                  child: InputDecorator(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    child: Text("data"),
                  ),
                ),
              ),
              Step(
                title: Text("Chọn thợ"),
                content: GestureDetector(
                  child: InputDecorator(
                    decoration: InputDecoration(),
                    child: Text("data"),
                  ),
                ),
              ),
              Step(
                title: Text("Đặt lịch"),
                content: GestureDetector(
                  child: InputDecorator(
                    decoration: InputDecoration(),
                    child: Text("data"),
                  ),
                ),
              ),
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _load() {
    widget._scheduleBloc.add(LoadScheduleEvent());
  }
}
