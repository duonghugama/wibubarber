import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:wibubarber/model/style_model.dart';
import 'package:wibubarber/schedule/index.dart';
import 'package:wibubarber/style/index.dart';

class ServicePickScreen extends StatefulWidget {
  const ServicePickScreen({super.key, required ScheduleBloc bloc}) : _bloc = bloc;
  final ScheduleBloc _bloc;
  @override
  State<ServicePickScreen> createState() => _ServicePickScreenState();
}

class _ServicePickScreenState extends State<ServicePickScreen> {
  late TabController tabController;
  final f = NumberFormat.currency(locale: "vi", symbol: "K");
  TextStyle whiteText = TextStyle(color: Colors.white, fontSize: 13);
  final StyleBloc _styleBloc = StyleBloc(UnStyleState());
  int colorSelected = -1;
  int styleSelected = -1;
  String style = ScheduleEvent.stylename;
  String color = ScheduleEvent.colorName;
  int index = 0;
  Widget image(StyleModel? model) {
    if (model?.imageURL != null && model?.imageURL != "") {
      return FadeInImage.assetNetwork(
        image: model!.imageURL!,
        placeholder: 'lib/asset/loading-azurlane.gif',
        fit: BoxFit.fill,
      );
    }
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Image.asset(
          "lib/asset/no-photos.png",
        ),
      ),
    );
  }

  Color invert(Color color) {
    final r = 255 - color.red;
    final g = 255 - color.green;
    final b = 255 - color.blue;

    return Color.fromARGB((color.opacity * 255).round(), r, g, b);
  }

  @override
  void initState() {
    super.initState();
    _styleBloc.add(LoadStyleEvent());
    styleSelected = -1;
    colorSelected = -1;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: AutoSizeText(style.isNotEmpty ? style + (color.isNotEmpty ? " + màu: $color" : "") : "",
              maxLines: 3),
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
          // actions: [
          //   Center(
          //     child: Text(color),
          //   ),
          // ],
        ),
        body: BlocBuilder<ScheduleBloc, ScheduleState>(
          bloc: widget._bloc,
          builder: (context, state) {
            if (state is InScheduleState)
              return BlocBuilder<StyleBloc, StyleState>(
                bloc: _styleBloc,
                builder: (context, state) {
                  if (state is InStyleState) {
                    if (state.styles != null) {
                      return TabBarView(
                        children: [
                          GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 1.8),
                            ),
                            itemCount: state.styles?.length ?? 0,
                            itemBuilder: (context, index) {
                              List<String> timeParts = state.styles![index].styleTime!.split(':');
                              Duration duration = Duration(
                                hours: int.parse(timeParts[0]),
                                minutes: int.parse(timeParts[1]),
                                seconds: int.parse(timeParts[2]),
                              );
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    styleSelected = styleSelected == index ? -1 : index;
                                    style = styleSelected != -1 ? state.styles![index].styleName ?? "" : "";
                                  });
                                },
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    side: styleSelected == index
                                        ? BorderSide(color: Theme.of(context).primaryColor, width: 5)
                                        : BorderSide(color: Colors.white, width: 0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2,
                                  child: SizedBox(
                                    height: 500,
                                    child: Stack(
                                      children: [
                                        image(state.styles![index]),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          left: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.black.withAlpha(0),
                                                  Colors.black45,
                                                  Colors.black45,
                                                  Colors.black45,
                                                  // Colors.black12,
                                                ],
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${state.styles![index].styleName ?? ""} - ${duration.inMinutes} phút",
                                                  style: whiteText,
                                                ),
                                                Text(
                                                  state.styles?[index].description ?? "",
                                                  style: whiteText,
                                                ),
                                                Text(
                                                  "Giá: ${f.format(state.styles![index].stylePrice! / 1000)}",
                                                  style: whiteText,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 1.4),
                            ),
                            itemCount: state.colors?.length ?? 0,
                            itemBuilder: (context, index) {
                              List<String> timeParts = state.colors![index].time.split(':');
                              Duration duration = Duration(
                                hours: int.parse(timeParts[0]),
                                minutes: int.parse(timeParts[1]),
                                seconds: int.parse(timeParts[2]),
                              );
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    colorSelected = colorSelected == index ? -1 : index;
                                    color = colorSelected != -1 ? state.colors![index].name : "";
                                  });
                                },
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    side: colorSelected == index
                                        ? BorderSide(color: Theme.of(context).primaryColor, width: 5)
                                        : BorderSide(color: Colors.white, width: 0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 4,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        color: HexColor(state.colors![index].hex),
                                      ),
                                      Center(
                                        child: Text(
                                          state.colors![index].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: invert(
                                              HexColor(state.colors![index].hex),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 5,
                                        child: Text(
                                          "Giá: ${f.format(state.colors![index].price / 1000)} \n${duration.inMinutes}p",
                                          style: TextStyle(
                                            color: invert(
                                              HexColor(state.colors![index].hex),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: Text("Úi hiện không có kiểu tóc hay râu ria lào luôn!"),
                      );
                    }
                  }
                  return Center(
                    child: Image.asset('lib/asset/loading-azurlane.gif'),
                  );
                },
              );
            return Center(
              child: Text("Úi có lỗi sảy ra"),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            widget._bloc.add(SelectServicesEvent(style, color));
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
