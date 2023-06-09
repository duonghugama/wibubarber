import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/model/style_model.dart';
import 'package:wibubarber/style/index.dart';
import 'package:intl/intl.dart';

class StyleScreen extends StatefulWidget {
  const StyleScreen({
    required StyleBloc styleBloc,
    Key? key,
  })  : _styleBloc = styleBloc,
        super(key: key);

  final StyleBloc _styleBloc;

  @override
  StyleScreenState createState() {
    return StyleScreenState();
  }
}

class StyleScreenState extends State<StyleScreen> {
  StyleScreenState();
  // Initial Selected Value
  String dropdownvalue = 'Kiểu tóc';
  final f = NumberFormat.currency(locale: "vi", symbol: "K");
  // List of items in our dropdown menu
  var items = [
    'Kiểu tóc',
    'Kiểu râu',
    'Màu tóc',
  ];
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  TextStyle whiteText = TextStyle(color: Colors.white, fontSize: 16);
  TextStyle yellowText = TextStyle(color: Colors.yellow[300], fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StyleBloc, StyleState>(
      bloc: widget._styleBloc,
      listener: (context, state) {
        if (state is ErrorStyleState) {
          final snackbar = SnackBar(
            content: Text("Có lỗi sảy ra"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      builder: (
        BuildContext context,
        StyleState currentState,
      ) {
        if (currentState is ErrorStyleState) {
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
        if (currentState is UnStyleState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (currentState is InStyleState) {
          if (currentState.styles != null) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.8),
              ),
              itemCount: currentState.styles?.length ?? 0,
              itemBuilder: (context, index) {
                List<String> timeParts = currentState.styles![index].styleTime!.split(':');
                Duration duration = Duration(
                  hours: int.parse(timeParts[0]),
                  minutes: int.parse(timeParts[1]),
                  seconds: int.parse(timeParts[2]),
                );
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddStyleScreen(
                          styleModel: currentState.styles![index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    child: Stack(
                      children: [
                        image(currentState.styles![index]),
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
                                  "${currentState.styles![index].styleName ?? ""} - ${duration.inMinutes} phút",
                                  style: whiteText,
                                ),
                                Text(
                                  currentState.styles?[index].description ?? "",
                                  style: whiteText,
                                ),
                                Text(
                                  "Giá: ${f.format(currentState.styles![index].stylePrice! / 1000)}",
                                  style: whiteText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _load() {
    widget._styleBloc.add(LoadStyleEvent());
  }
}
