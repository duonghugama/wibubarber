import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wibubarber/barber/index.dart';

class BarberScreen extends StatefulWidget {
  const BarberScreen({
    required BarberBloc barberBloc,
    Key? key,
  })  : _barberBloc = barberBloc,
        super(key: key);

  final BarberBloc _barberBloc;

  @override
  BarberScreenState createState() {
    return BarberScreenState();
  }
}

class BarberScreenState extends State<BarberScreen> {
  BarberScreenState();
  PlatformFile? pickedFile;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

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
    return BlocBuilder<BarberBloc, BarberState>(
      bloc: widget._barberBloc,
      builder: (
        BuildContext context,
        BarberState currentState,
      ) {
        if (currentState is UnBarberState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (currentState is ErrorBarberState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    onPressed: _load,
                    child: Text('reload'),
                  ),
                ),
              ],
            ),
          );
        }
        if (currentState is InBarberState) {
          if (currentState.barbers.isNotEmpty) {
            return ListView.builder(
              itemCount: currentState.barbers.length,
              itemBuilder: (context, index) {
                var img = (currentState.barbers[index].avatarURL ?? "") != ""
                    ? Image.network(
                        currentState.barbers[index].avatarURL!,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        "lib/asset/barber.png",
                        fit: BoxFit.fill,
                      );
                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Card(
                    color: Colors.white70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: img,
                          ),
                          title: Text(
                            currentState.barbers[index].name ?? "",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "Kinh nghiệm: ${currentState.barbers[index].exp} \n${currentState.barbers[index].description ?? ""}"),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => <PopupMenuEntry<TextButton>>[
                              PopupMenuItem<TextButton>(
                                child: TextButton(
                                  onPressed: () {
                                    widget._barberBloc
                                        .add(DeleteBarber(currentState.barbers[index].email ?? ""));
                                  },
                                  child: Text(
                                    "Đuổi việc",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Text(currentState.barbers[index].description ?? ""),
                      ],
                    ),
                  ),
                );
              },
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
    widget._barberBloc.add(LoadBarberEvent());
  }
}
