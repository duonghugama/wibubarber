import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:wibubarber/style/index.dart';

class ColorScreen extends StatefulWidget {
  const ColorScreen({required StyleBloc styleBloc, super.key}) : _styleBloc = styleBloc;
  final StyleBloc _styleBloc;

  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  final f = NumberFormat.currency(locale: "vi", symbol: "K");
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyleBloc, StyleState>(
      bloc: widget._styleBloc,
      builder: (context, state) {
        if (state is InStyleState)
          return Wrap(
            children: state.colors!
                .map(
                  (e) => Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4,
                    child: Column(
                      children: [
                        Container(
                          color: HexColor(e.hex),
                          height: MediaQuery.of(context).size.width * 0.4,
                          width: MediaQuery.of(context).size.width / 3.3,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3.3,
                          child: Center(
                            child: Text(
                              e.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3.3,
                          child: Text("Giá: ${f.format(e.price / 1000)}"),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        return Container();
      },
    );
  }
}
