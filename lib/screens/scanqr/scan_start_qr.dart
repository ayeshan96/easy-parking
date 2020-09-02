import 'package:flutter/material.dart';
import 'package:flutterapp/screens/scanqr/scan_start_qr2.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

class ScanStartQR extends StatefulWidget {
  String hemawelemaoni;
  String parkRequestId;
  String valueFromFirebaseForQR;
  String paName;
  ScanStartQR({this.hemawelemaoni,this.parkRequestId,this.valueFromFirebaseForQR,this.paName});

  @override
  _ScanStartQRState createState() => _ScanStartQRState(hemawelemaoni:hemawelemaoni,parkRequestId:parkRequestId,valueFromFirebaseForQR:valueFromFirebaseForQR,paName:paName);
}

class _ScanStartQRState extends State<ScanStartQR> {

  String hemawelemaoni;
  String parkRequestId;
  String valueFromFirebaseForQR;
  String paName;
  _ScanStartQRState({this.hemawelemaoni,this.parkRequestId,this.valueFromFirebaseForQR,this.paName});


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
                  'Please Scan QR Code For Enter the Park....!',
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

        if (valueFromFirebaseForQR == qrText) {
          print('####$valueFromFirebaseForQR###########$qrText##################');
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) =>
                      ScanStartQR2(hemawelemaoni: hemawelemaoni,
                        parkRequestId: parkRequestId,
                      )));
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


/*class _ScanStartQRState extends State<ScanStartQR> {

  String hemawelemaoni;
  String parkRequestId;
  String valueFromFirebaseForQR;
  _ScanStartQRState({this.hemawelemaoni,this.parkRequestId,this.valueFromFirebaseForQR});

  bool temp=false;

  GlobalKey qrKey=GlobalKey();
  String qrText="";
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
      children: <Widget>[
        Expanded(
          flex: 5,
            child: QRView(key: qrKey,
              overlay:QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Colors.red,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300),
              onQRViewCreated: _onQRViewCreate,),

        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text('Scan The QR Code\n$qrText\n$valueFromFirebaseForQR'),
          ),
        ),
      ],
    ) ,);
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    if (temp != false) {
      controller.scannedDataStream.listen((scanData) {
        setState(() {
          qrText = '$scanData';
          print('WWWWWWWWWWWWWWWWWWW${temp}WWWWWWWWWWWWWWWWWWWWWWWWWWWW');
         /* if (valueFromFirebaseForQR == qrText) {
            temp=true;
            print(
                '####$valueFromFirebaseForQR###########$qrText########$temp##########');
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) =>
                        ScanStartQR2(hemawelemaoni: hemawelemaoni,
                          parkRequestId: parkRequestId,
                        )));
          }
          else {
            print('wrong value');
          }*/
        },);
      });
    }
  }
}*/



