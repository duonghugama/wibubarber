import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wibubarber/barber/barber_detail_screen.dart';
import 'package:wibubarber/barber/index.dart';
import 'package:wibubarber/login/index.dart';

class BarberPage extends StatefulWidget {
  static const String routeName = '/barber';

  @override
  _BarberPageState createState() => _BarberPageState();
}

class _BarberPageState extends State<BarberPage> {
  final _barberBloc = BarberBloc(UnBarberState());
  late String qr = "";
  @override
  Widget build(BuildContext context) {
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
            title: Text("Thợ cắt tóc"),
          ),
          body: BarberScreen(barberBloc: _barberBloc),
          floatingActionButton: LoginEvent.permission.contains("Admin")
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QRScanningPage(barberBloc: _barberBloc),
                      ),
                    );
                  },
                )
              : null,
        ),
      ],
    );
  }
}

class QRScanningPage extends StatefulWidget {
  const QRScanningPage({
    required BarberBloc barberBloc,
    Key? key,
  })  : _barberBloc = barberBloc,
        super(key: key);
  final BarberBloc _barberBloc;

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
      var value = await Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (context) => BarberDetailScreen(
              barberBloc: widget._barberBloc,
              email: result!.code!.split(',')[1].toString(),
              name: result!.code!.split(',')[0].toString(),
            ),
          ))
          .then((value) => controller.resumeCamera());
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
