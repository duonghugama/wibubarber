import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/schedule/index.dart';

class ServicePickScreen extends StatefulWidget {
  const ServicePickScreen({super.key, required ScheduleBloc bloc}) : _bloc = bloc;
  final ScheduleBloc _bloc;
  @override
  State<ServicePickScreen> createState() => _ServicePickScreenState();
}

class _ServicePickScreenState extends State<ServicePickScreen> {
  late TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is InScheduleState) return Container();
          return Center(
            child: Text("Úi có lỗi sảy ra"),
          );
        },
      ),
    );
  }
}
