import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wibubarber/barber/index.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Barber"),
      ),
      body: BarberScreen(barberBloc: _barberBloc),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QRScanningPage(),
            ),
          );
        },
      ),
    );
  }
}

class QRScanningPage extends StatefulWidget {
  const QRScanningPage({super.key});

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
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (result?.code != null) {
        showAlertDialog(context, result!.code!.split(',')[1].toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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

showAlertDialog(BuildContext context, String username) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Không"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Xác nhận"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Thông báo"),
    content: Text("Xác nhận $username làm thợ của cửa hàng?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
