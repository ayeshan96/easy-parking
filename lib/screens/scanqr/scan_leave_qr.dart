import 'package:flutter/material.dart';
import 'package:flutterapp/screens/scanqr/scan_leave_qr2.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

class ScanLeaveQR extends StatefulWidget {
  String hemawelemaoni;
  String valueFromFirebaseForQRLeaving;
  String paName;
  ScanLeaveQR({this.hemawelemaoni,this.valueFromFirebaseForQRLeaving,this.paName});

  @override
  _ScanLeaveQRState createState() => _ScanLeaveQRState(hemawelemaoni:hemawelemaoni,valueFromFirebaseForQRLeaving:valueFromFirebaseForQRLeaving,paName:paName);
}

class _ScanLeaveQRState extends State<ScanLeaveQR> {

  String hemawelemaoni;
  String valueFromFirebaseForQRLeaving;
  String paName;
  _ScanLeaveQRState({this.hemawelemaoni,this.valueFromFirebaseForQRLeaving,this.paName});


  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 10,
            child: QRView(key: qrKey,
              overlay:QrScannerOverlayShape(
                  borderRadius: 10,
                  borderColor: Colors.red,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300),
              onQRViewCreated: _onQRViewCreated,),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '\"$paName\"',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Please Scan QR Code For Leave the Park....!',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        controller.pauseCamera();
        print('WWWWWWWWWWWWW${qrText}WWWWWWWWWWWWWWWWWWWWWWWWWW');

        if (valueFromFirebaseForQRLeaving == qrText) {
          print('####$valueFromFirebaseForQRLeaving###########$qrText##################');
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) =>
                      ScanSLeaveQR2(hemawelemaoni: hemawelemaoni,)));
        }
        else {
          print('wrong value');
          controller.resumeCamera();
        }


      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}


