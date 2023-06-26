import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wibubarber/barber/index.dart';
import 'package:wibubarber/home/home_screen.dart';
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
  AutoScrollController scrollController = AutoScrollController();
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Đặt lịch thành công"),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
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
            child: SingleChildScrollView(
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
              ),
            ),
          );
        }
        if (state is InScheduleState) {
          String dichvu = "Chọn dịch vụ";
          if (state.style != "") {
            dichvu = state.style;
          }
          if (state.color != "") {
            dichvu += " với màu tóc ${state.color}";
          }
          return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white70,
            ),
            child: Stepper(
              controlsBuilder: (context, details) => SizedBox.shrink(),
              currentStep: _index,
              type: StepperType.vertical,
              onStepTapped: (int index) {
                setState(() {
                  if (index == 1) _barberBloc.add(LoadBarberEvent());
                  if (index == 2) {
                    if (barber != "")
                      widget._scheduleBloc.add(
                        SelectBarberAndDatetimeEvent(barber, dropdownvalue),
                      );
                    else
                      return;
                  }
                  _index = index;
                });
              },
              steps: [
                Step(
                  title: Text(
                    "Chọn gói dịch vụ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ServicePickScreen(bloc: widget._scheduleBloc)),
                      );
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        prefixIcon: Icon(Icons.cut),
                        suffixIcon: Icon(Icons.arrow_forward_ios),
                      ),
                      child:
                          Text((state.style.isNotEmpty || state.color.isNotEmpty) ? dichvu : "Chọn dịch vụ"),
                    ),
                  ),
                ),
                Step(
                  title: Text(
                    "Chọn thợ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: BlocBuilder<BarberBloc, BarberState>(
                    bloc: _barberBloc,
                    builder: (context, state) {
                      if (state is InBarberState)
                        return InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          ),
                          child: ExpansionTile(
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
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: e.email! == barber ? 5 : 0,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: e.avatarURL ??
                                                        "https://png2.cleanpng.com/sh/596fdbc47761d72497fc727dd8037788/L0KzQYm3VsA1N5poipH0aYP2gLBuTfNwdaF6jNd7LXnmf7B6TfF3aaVmip9Ac3X1PcH5jBZqdJYyiNd7c3BxPbF8lPxqdpYyTdQ6NXW7SYiAUsY1PGEzUagAM0O2QoS4VcI5OWc3TKcANEa7RnB3jvc=/kisspng-computer-icons-avatar-user-profile-person-outline-5b15e897726440.9653332315281624554686.png",
                                                    height: 90,
                                                    width: 90,
                                                    placeholder: (context, url) =>
                                                        Image.asset('lib/asset/loading-azurlane.gif'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              // Container(
                                              //   width: 100,
                                              //   height: 100,
                                              //   decoration: BoxDecoration(
                                              //     color: Color(0xff7c94b6),
                                              //     image: DecorationImage(
                                              //       image: NetworkImage(
                                              //         e.avatarURL ??
                                              //             "https://pngtree.com/freepng/user-vector-avatar_4830521.html",
                                              //       ),
                                              //       fit: BoxFit.cover,
                                              //     ),
                                              //     shape: BoxShape.circle,
                                              //     border: Border.all(
                                              //       width: e.email! == barber ? 5 : 0,
                                              //       color: Theme.of(context).primaryColor,
                                              //     ),
                                              //   ),
                                              // ),
                                              Text(
                                                e.name ?? "",
                                                style: TextStyle(
                                                  color: e.email! == barber ? Colors.red : Colors.black,
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
                          ),
                        );
                      return ExpansionTile(
                        leading: Icon(Icons.person),
                        title: Text("Chọn barber"),
                      );
                    },
                  ),
                ),
                Step(
                  title: Text(
                    "Đặt lịch",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Colors.white,
                        ),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey[300]),
                          child: DropdownButtonHideUnderline(
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
                            childAspectRatio: MediaQuery.of(context).size.width /
                                (MediaQuery.of(context).size.height / 1.2),
                          ),
                          itemCount: 24,
                          itemBuilder: (context, index) {
                            if (state.scheduled.contains("${index.toString().padLeft(2, "0")}:00")) {
                              scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
                            }
                            return AutoScrollTag(
                              controller: scrollController,
                              index: index,
                              key: ValueKey(index),
                              child: Card(
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
                            );
                          },
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
    widget._scheduleBloc.add(LoadScheduleEvent());
  }
}
