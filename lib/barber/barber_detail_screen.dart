import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import 'index.dart';

class BarberDetailScreen extends StatefulWidget {
  const BarberDetailScreen({
    required BarberBloc barberBloc,
    Key? key,
    required this.email,
    required this.name,
  })  : _barberBloc = barberBloc,
        super(key: key);
  final BarberBloc _barberBloc;
  final String email;
  final String name;
  @override
  State<BarberDetailScreen> createState() => _BarberDetailScreenState();
}

class _BarberDetailScreenState extends State<BarberDetailScreen> {
  TextEditingController barberNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BarberBloc, BarberState>(
      bloc: widget._barberBloc,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Thêm thợ cắt tóc"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(FontAwesome5.save),
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: barberNameController,
                decoration: InputDecoration(
                  labelText: "Email barber",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nhập Email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: barberNameController,
                decoration: InputDecoration(
                  labelText: "Tên barber",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nhập tên';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: barberNameController,
                decoration: InputDecoration(
                  labelText: "Kinh nghiệm",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                ),
                keyboardType: TextInputType.text,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Nhập tên';
                //   }
                //   return null;
                // },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: barberNameController,
                decoration: InputDecoration(
                  labelText: "Mô tả thêm",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                ),
                keyboardType: TextInputType.text,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Nhập tên';
                //   }
                //   return null;
                // },
              ),
            ],
          ),
        );
      },
    );
  }
}
