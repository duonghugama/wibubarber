import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/model/style_model.dart';
import 'package:wibubarber/style/index.dart';

class AddStyleScreen extends StatefulWidget {
  const AddStyleScreen({super.key});

  @override
  State<AddStyleScreen> createState() => _AddStyleScreenState();
}

class _AddStyleScreenState extends State<AddStyleScreen> {
  TextEditingController styleNameController = TextEditingController();
  TextEditingController stylePriceController = TextEditingController();
  TextEditingController styleDecriptionController = TextEditingController();
  TextEditingController styleTimeController = TextEditingController();
  List<String> styleTypes = ["Kiểu tóc", "Kiểu râu", "Khác"];
  String drowdownValue = "Kiểu tóc";
  formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return BlocListener<StyleBloc, StyleState>(
      listener: (context, state) {
        if (state is AddStyleSuccessState) {
          final snackBar = SnackBar(
            content: const Text('Thêm style thành công'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Thêm style"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: styleNameController,
                  decoration: InputDecoration(
                    labelText: "Tên style",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: stylePriceController,
                  decoration: InputDecoration(
                    labelText: "Giá",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Loại style",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                    value: drowdownValue,
                    items: styleTypes
                        .map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        drowdownValue = value!;
                      });
                    },
                  ),
                ),
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
                ),
                SizedBox(height: 10),
                TextField(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            StyleModel model = StyleModel(
              styleType: drowdownValue,
              styleTime: styleTimeController.text,
              styleName: styleNameController.text,
              stylePrice: int.parse(stylePriceController.text),
              description: styleDecriptionController.text,
            );
            BlocProvider.of<StyleBloc>(context).add(AddStyleEvent(model));
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
