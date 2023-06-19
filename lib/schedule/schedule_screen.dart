import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/barber/index.dart';
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
  final BarberBloc _barberBloc = BarberBloc(UnBarberState());
  ScheduleScreenState();
  int _index = 0;
  String barber = "";
  final DateTime now = DateTime.now();
  DateTime dropdownvalue = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int schedule = -1;
  @override
  void initState() {
    super.initState();
    barber = "";
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      bloc: widget._scheduleBloc,
      listener: (context, state) {
        if (state is ScheduleSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đặt lịch thành công")));
          Navigator.of(context).pop();
        }
      },
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
          String dichvu = "Chọn dịch vụ";
          if (state.style != "") {
            dichvu = state.style;
          }
          if (state.color != "") {
            dichvu += " với màu tóc ${state.color}";
          }
          return Stepper(
            controlsBuilder: (context, details) => SizedBox.shrink(),
            currentStep: _index,
            onStepTapped: (int index) {
              setState(() {
                _index = index;
                if (index == 1) _barberBloc.add(LoadBarberEvent());
                if (index == 2)
                  widget._scheduleBloc.add(
                    SelectBarberAndDatetimeEvent(barber, dropdownvalue),
                  );
              });
            },
            steps: [
              Step(
                title: Text("Chọn gói dịch vụ"),
                content: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ServicePickScreen(bloc: widget._scheduleBloc)),
                    );
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      prefixIcon: Icon(Icons.cut),
                      suffixIcon: Icon(Icons.arrow_forward_ios),
                    ),
                    child: Text((state.style.isNotEmpty || state.color.isNotEmpty) ? dichvu : "Chọn dịch vụ"),
                  ),
                ),
              ),
              Step(
                title: Text("Chọn thợ"),
                content: BlocBuilder<BarberBloc, BarberState>(
                  bloc: _barberBloc,
                  builder: (context, state) {
                    if (state is InBarberState)
                      return ExpansionTile(
                        leading: Icon(Icons.person),
                        title: Text("Chọn barber"),
                        children: [
                          SingleChildScrollView(
                            child: Row(
                              children: state.barbers
                                  .map(
                                    (e) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (barber != e.email)
                                            barber = e.email ?? "";
                                          else
                                            barber = "";
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Color(0xff7c94b6),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  e.avatarURL ??
                                                      "https://pngtree.com/freepng/user-vector-avatar_4830521.html",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: e.email! == barber ? 5 : 0,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            e.name ?? "",
                                            style: TextStyle(
                                              color: e.email! == barber ? Colors.red : Colors.black,
                                              fontWeight:
                                                  e.email! == barber ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      );
                    return ExpansionTile(
                      leading: Icon(Icons.person),
                      title: Text("Chọn barber"),
                    );
                  },
                ),
              ),
              Step(
                title: Text("Đặt lịch"),
                content: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<DateTime>(
                            isExpanded: true,
                            value: dropdownvalue,
                            items: [
                              DropdownMenuItem(
                                value: DateTime(now.year, now.month, now.day),
                                child: ListTile(
                                  title: Text("Hôm nay"),
                                ),
                              ),
                              DropdownMenuItem(
                                value: DateTime(now.year, now.month, now.day).add(Duration(days: 1)),
                                child: ListTile(
                                  title: Text("Ngày mai"),
                                ),
                              ),
                              DropdownMenuItem(
                                value: DateTime(now.year, now.month, now.day).add(Duration(days: 2)),
                                child: ListTile(
                                  title: Text("Ngày kia"),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                dropdownvalue = value ?? DateTime(now.year, now.month, now.day);
                              });
                              widget._scheduleBloc.add(
                                SelectBarberAndDatetimeEvent(barber, dropdownvalue),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio:
                              MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.2),
                        ),
                        itemCount: 24,
                        itemBuilder: (context, index) => Card(
                          elevation: 5,
                          color: (state.scheduled.contains("${index.toString().padLeft(2, "0")}:00") ||
                                  index < 7)
                              ? Colors.grey
                              : Colors.blue,
                          shape: RoundedRectangleBorder(
                            side: schedule == index
                                ? BorderSide(color: Colors.red, width: 5)
                                : BorderSide(color: Colors.white, width: 0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (!state.scheduled.contains("${index.toString().padLeft(2, "0")}:00") ||
                                  index > 7)
                                setState(() {
                                  schedule = index;
                                });
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Xin vui lòng chọn giờ khác"),
                                  ),
                                );
                              }
                            },
                            child: Center(
                              child: Text(
                                "${index.toString().padLeft(2, "0")}:00",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Hoàn thành đặt lịch"),
                            content: Text("Bạn có chắc hoàn thành đặt lịch?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Chưa"),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget._scheduleBloc.add(AddSchedule(schedule, dropdownvalue));
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Text("Đồng ý"),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(Theme.of(context).buttonTheme.height), // NEW
                      ),
                      child: Text("Hoàn thành"),
                    )
                  ],
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
