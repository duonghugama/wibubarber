import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/style/index.dart';
import 'package:intl/intl.dart';

import 'add_style_screen.dart';

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
  final f = NumberFormat.currency(locale: "vi");
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: currentState.styles?.length ?? 0,
              itemBuilder: (context, index) {
                List<String> timeParts = currentState.styles![index].styleTime!.split(':');
                Duration duration = Duration(
                    hours: int.parse(timeParts[0]), minutes: int.parse(timeParts[1]), seconds: int.parse(timeParts[2]));
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
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Text("${duration.inMinutes} phút"),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Text(
                              "${currentState.styles![index].styleName ?? ""} - ${f.format(currentState.styles![index].stylePrice)}"),
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
