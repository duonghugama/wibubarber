import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  TextStyle whiteText = TextStyle(color: Colors.white, fontSize: 16);
  final StyleBloc _styleBloc = StyleBloc(UnStyleState());
  List<bool> isSelected = [];
  String selected = "";
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

  @override
  void initState() {
    super.initState();
    _styleBloc.add(LoadStyleEvent());
    isSelected = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selected),
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
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.8),
                      ),
                      itemCount: state.styles?.length ?? 0,
                      itemBuilder: (context, index) {
                        List<String> timeParts = state.styles![index].styleTime!.split(':');
                        Duration duration = Duration(
                          hours: int.parse(timeParts[0]),
                          minutes: int.parse(timeParts[1]),
                          seconds: int.parse(timeParts[2]),
                        );
                        isSelected.add(false);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              for (var i = 0; i < isSelected.length; i++) {
                                isSelected[i] = false;
                              }
                              isSelected[index] = !isSelected[index];
                              selected = state.styles![index].styleName ?? "";
                            });
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              side: isSelected[index]
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
                    );
                  } else {
                    return Center(
                      child: Text("Úi hiện không có kiểu tóc hay râu ria lào luôn!"),
                    );
                  }
                }
                return Container();
              },
            );
          return Center(
            child: Text("Úi có lỗi sảy ra"),
          );
        },
      ),
    );
  }
}
