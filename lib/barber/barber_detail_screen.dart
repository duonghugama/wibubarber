import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:wibubarber/model/barber_model.dart';

import 'index.dart';

class BarberDetailScreen extends StatefulWidget {
  const BarberDetailScreen({
    required BarberBloc barberBloc,
    Key? key,
    required String email,
    required String name,
    this.barber,
  })  : _name = name,
        _email = email,
        _barberBloc = barberBloc,
        super(key: key);
  final BarberBloc _barberBloc;
  final String _email;
  final String _name;
  final BarberModel? barber;
  @override
  State<BarberDetailScreen> createState() => _BarberDetailScreenState();
}

class _BarberDetailScreenState extends State<BarberDetailScreen> {
  PlatformFile? pickedFile;
  TextEditingController barberNameController = TextEditingController();
  TextEditingController barberEmailController = TextEditingController();
  TextEditingController barberExpController = TextEditingController();
  TextEditingController barberDescripController = TextEditingController();
  @override
  void initState() {
    super.initState();
    barberEmailController.text = widget._email;
    barberNameController.text = widget._name;
    if (widget.barber != null) {
      barberNameController.text = widget.barber!.name ?? "";
      barberEmailController.text = widget.barber!.email ?? "";
      barberExpController.text = widget.barber!.exp ?? "";
      barberDescripController.text = widget.barber!.description ?? "";
    }
  }

  Widget _image(String? path) {
    if (path != null) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
      );
    }
    if (widget.barber?.avatarURL != null && widget.barber?.avatarURL != "") {
      return Image.network(
        widget.barber!.avatarURL!,
        fit: BoxFit.fill,
      );
    }
    return Icon(Icons.add_a_photo);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BarberBloc, BarberState>(
      bloc: widget._barberBloc,
      listener: (context, state) {
        if (state is AddBarberState) {
          final snackBar = SnackBar(
            content: Text('Thêm thợ cắt tóc thành công'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Image.asset(
              "lib/asset/background/background1.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Thêm thợ cắt tóc"),
                actions: [
                  IconButton(
                    onPressed: () {
                      widget._barberBloc.add(
                        AddBarberEvent(
                          barberEmailController.text,
                          barberExpController.text,
                          barberNameController.text,
                          barberDescripController.text,
                          pickedFile,
                          widget.barber?.avatarURL ?? "",
                        ),
                      );
                    },
                    icon: Icon(FontAwesome5.save),
                  ),
                ],
              ),
              body: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectFile,
                        child: ClipOval(
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: _image(pickedFile?.path),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: barberEmailController,
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
                        enabled: false,
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
                        controller: barberExpController,
                        decoration: InputDecoration(
                          labelText: "Kinh nghiệm",
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
                        controller: barberDescripController,
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
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
