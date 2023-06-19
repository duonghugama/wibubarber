import 'dart:io';

import 'package:duration_picker/duration_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/model/style_model.dart';
import 'package:wibubarber/style/index.dart';

class StyleDetailScreen extends StatefulWidget {
  final StyleModel? styleModel;
  StyleDetailScreen({super.key, this.styleModel});

  @override
  State<StyleDetailScreen> createState() => _StyleDetailScreenState();
}

class _StyleDetailScreenState extends State<StyleDetailScreen> {
  PlatformFile? pickedFile;
  TextEditingController styleNameController = TextEditingController();
  TextEditingController stylePriceController = TextEditingController();
  TextEditingController styleDecriptionController = TextEditingController();
  TextEditingController styleTimeController = TextEditingController();
  List<String> styleTypes = ["Kiểu tóc", "Kiểu râu", "Khác"];
  String drowdownValue = "Kiểu tóc";
  final _formKey = GlobalKey<FormState>();

  formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, "0");
  Widget _image(String? path) {
    if (path != null) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
      );
    }
    if (widget.styleModel?.imageURL != null && widget.styleModel?.imageURL != "") {
      return Image.network(
        widget.styleModel!.imageURL!,
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
  void initState() {
    if (widget.styleModel != null) {
      styleNameController.text = widget.styleModel!.styleName ?? "";
      stylePriceController.text = widget.styleModel!.stylePrice?.toString() ?? "";
      styleTimeController.text = widget.styleModel!.styleTime ?? "";
      styleDecriptionController.text = widget.styleModel!.description ?? "";
      // drowdownValue = widget.styleModel!.styleType ?? "Kiểu tóc";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StyleBloc, StyleState>(
      listener: (context, state) {
        if (state is AddStyleSuccessState) {
          final snackBar = SnackBar(
            content: Text('Thêm ${drowdownValue.toLowerCase()} thành công'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop();
        }
        if (state is UpdateStyleSuccessState) {
          final snackBar = SnackBar(
            content: Text('Sửa ${drowdownValue.toLowerCase()} thành công'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.styleModel == null ? "Thêm style" : widget.styleModel!.styleName ?? "Sửa style"),
          actions: [
            widget.styleModel != null
                ? IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Xác nhận xoá"),
                          content: Text("Bạn có chắc xoá kiểu tóc này?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Chưa"),
                            ),
                            TextButton(
                              onPressed: () {
                                if (widget.styleModel != null) {
                                  BlocProvider.of<StyleBloc>(context)
                                      .add(DeleteStyleEvent(widget.styleModel!));
                                  Navigator.pop(context);
                                }
                                Navigator.of(context).pop();
                              },
                              child: Text("Đồng ý"),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.delete),
                  )
                : Container(),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: selectFile,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.grey[300],
                        child: _image(pickedFile?.path),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: styleNameController,
                    decoration: InputDecoration(
                      labelText: "Tên style",
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
                    controller: stylePriceController,
                    decoration: InputDecoration(
                      labelText: "Giá",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập giá của style';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // DropdownButtonHideUnderline(
                  //   child: DropdownButtonFormField<String>(
                  //     decoration: InputDecoration(
                  //       labelText: "Loại style",
                  //       border: OutlineInputBorder(),
                  //       contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  //     ),
                  //     value: drowdownValue,
                  //     items: styleTypes
                  //         .map((e) => DropdownMenuItem<String>(
                  //               value: e,
                  //               child: Text(e),
                  //             ))
                  //         .toList(),
                  //     onChanged: (value) {
                  //       setState(() {
                  //         drowdownValue = value!;
                  //       });
                  //     },
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: styleTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Thời gian",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                    onTap: () {
                      setState(() {
                        openDialog();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập khoảng thời gian thực hiện';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: styleDecriptionController,
                    decoration: InputDecoration(
                      labelText: "Mô tả",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              StyleModel model = StyleModel(
                // styleType: drowdownValue,
                styleTime: styleTimeController.text,
                styleName: styleNameController.text,
                stylePrice: int.parse(stylePriceController.text),
                description: styleDecriptionController.text,
              );
              if (widget.styleModel == null) {
                BlocProvider.of<StyleBloc>(context).add(AddStyleEvent(model, pickedFile));
              } else {
                BlocProvider.of<StyleBloc>(context).add(UpdateStyleEvent(model, pickedFile));
              }
            }
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }

  Future openDialog() {
    Duration duration = Duration(hours: 0, minutes: 0);
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          content: DurationPicker(
            duration: duration,
            onChange: (val) {
              setState(() => duration = val);
            },
            snapToMins: 5.0,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(
                  () => styleTimeController.text = formatDuration(duration),
                );
                Navigator.of(context).pop();
              },
              child: Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }
}
