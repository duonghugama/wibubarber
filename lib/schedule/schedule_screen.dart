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
        ScheduleState state,
      ) {
        if (state is UnScheduleState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ErrorScheduleState) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(state.errorMessage),
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
        if (state is InScheduleState) {
          int _index = 0;
          return Stepper(
            controlsBuilder: (context, details) => SizedBox.shrink(),
            currentStep: _index,
            // onStepCancel: () {
            //   if (_index > 0) {
            //     setState(() {
            //       _index -= 1;
            //     });
            //   }
            // },
            // onStepContinue: () {
            //   if (_index <= 0) {
            //     setState(() {
            //       _index += 1;
            //     });
            //   }
            // },
            onStepTapped: (int index) {
              setState(() {
                _index = index;
              });
            },
            steps: [
              Step(
                title: Text("Chọn gói dịch vụ"),
                content: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => Stylr
                    //   ),
                    // );
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      prefixIcon: Icon(Icons.cut),
                      suffixIcon: Icon(Icons.arrow_forward_ios),
                    ),
                    child: Text(
                      state.servicePackage.isNotEmpty
                          ? "Đã có ${state.servicePackage.length} dịch vụ đã chọn"
                          : "Chọn dịch vụ",
                    ),
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
