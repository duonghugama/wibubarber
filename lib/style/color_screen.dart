import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/style/index.dart';

class ColorScreen extends StatefulWidget {
  const ColorScreen({required StyleBloc styleBloc, super.key}) : _styleBloc = styleBloc;
  final StyleBloc _styleBloc;

  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyleBloc, StyleState>(
      bloc: widget._styleBloc,
      builder: (context, state) {
        return Container();
      },
    );
  }
}
