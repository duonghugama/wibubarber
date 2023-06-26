import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wibubarber/login/index.dart';

import 'index.dart';

class BarberHomeScreen extends StatefulWidget {
  const BarberHomeScreen({required HomeBloc homeBloc, super.key, required LoginBloc loginBloc})
      : _homeBloc = homeBloc,
        _loginBloc = loginBloc;
  final HomeBloc _homeBloc;
  final LoginBloc _loginBloc;
  @override
  State<BarberHomeScreen> createState() => _BarberHomeScreenState();
}

class _BarberHomeScreenState extends State<BarberHomeScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    return Stack(
      children: [
        Image.asset(
          "lib/asset/background/background.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Trang chủ thợ cắt tóc"),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        widget._homeBloc.add(LoadHomeEvent());
                      },
                      style: buttonStyle,
                      child: Text(
                        "Về chế độ khách hàng",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: BlocConsumer<HomeBloc, HomeState>(
            bloc: widget._homeBloc,
            listener: (context, state) {
              if (state is InHomeState) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              if (state is InBarberHomeState) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: state.schedule?.length ?? 0,
                    itemBuilder: (context, index) {
                      var img = (state.user?[index].imageUrl ?? "") != ""
                          ? Image.network(
                              state.user![index].imageUrl!,
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            )
                          : Image.asset(
                              "lib/asset/barber.png",
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            );
                      return Card(
                        color: Colors.white70,
                        child: Banner(
                          location: BannerLocation.topStart,
                          message: state.schedule![index].isConfirm ? "Đã hoàn thành" : "Chưa hoàn thành",
                          child: ListTile(
                            // visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: img,
                            ),
                            title: Text(
                              "Tên khách: ${state.user?[index].name ?? ""}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Kiểu tóc: ${state.style?[index].styleName ?? ""} ${state.color?[index].name ?? ""}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Text("Hẹn: ${state.schedule?[index].time ?? ""}"),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              if (state is UnHomeState)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Center(
                child: Container(),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(FontAwesome5.qrcode),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QRScanningPage(homeBloc: widget._homeBloc),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _load() {
    widget._homeBloc.add(LoadBarberHomeEvent());
  }
}

class QRScanningPage extends StatefulWidget {
  const QRScanningPage({
    required HomeBloc homeBloc,
    Key? key,
  })  : _homeBloc = homeBloc,
        super(key: key);
  final HomeBloc _homeBloc;

  @override
  State<QRScanningPage> createState() => _QRScanningPageState();
}

class _QRScanningPageState extends State<QRScanningPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  List<String> data = [];
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    secondPageRoute() async {
      controller.pauseCamera();
      widget._homeBloc.add(
        ConfirmScheduleEvent(
          result!.code!.split(',')[1].toString(),
          result!.code!.split(',')[2].toString(),
          result!.code!.split(',')[0].toString(),
          result!.code!.split(',')[3].toString(),
          result!.code!.split(',')[4].toString(),
        ),
      );
      widget._homeBloc.add(LoadBarberHomeEvent());
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Xác nhận thành công")));
      // var value = await Navigator.of(context)
      //     .push(MaterialPageRoute(
      //       builder: (context) {
      //         return
      //       }
      //       BarberDetailScreen(
      //       barberBloc: widget._homerBloc,
      //       email: result!.code!.split(',')[1].toString(),
      //       name: result!.code!.split(',')[0].toString(),
      //       ),
      //     ))
      //     .then((value) => controller.resumeCamera());
    }

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (result?.code != null) {
        // controller.pauseCamera();
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => BarberDetailScreen(
        //     barberBloc: widget._barberBloc,
        //     email: result!.code!.split(',')[0].toString(),
        //     name: result!.code!.split(',')[1].toString(),
        //   ),
        // ));
        secondPageRoute();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.cyan,
              borderWidth: 10,
              borderLength: 20,
              borderRadius: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white24),
              child: Text(
                result == null ? 'Quét mã của nhân viên!' : 'Tên nhân viên: ${result!.code}',
                maxLines: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
