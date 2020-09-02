import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/scanqr/scan_start_qr.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';

class MyHomePage extends StatefulWidget {

  String hemawelemaoni;
  MyHomePage({this.hemawelemaoni});

  @override
  _MyHomePageState createState() => _MyHomePageState(hemawelemaoni:hemawelemaoni);
}

class _MyHomePageState extends State<MyHomePage> {
  String hemawelemaoni;
  _MyHomePageState({this.hemawelemaoni});


  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Completer<GoogleMapController> _controller = Completer();

  //static const LatLng _center = const LatLng(6.9270786,79.861243);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  bool mapToggle = false;
  var currentLocation;
  var clients = [];

  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        populateClients();
        super.initState();
      });
    });
  }

  populateClients() {
    clients = [];
    Firestore.instance.collection('parkingmarkers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          initMarker(docs.documents[i].documentID, i);
        }
      }
    });
  }

  void initMarker(requestId, temp) {
    var markerIdval = requestId;
    final MarkerId markerId = MarkerId(markerIdval);

    Firestore.instance.collection('parkingmarkers').getDocuments().then((docs2) {
      int availableSlots = docs2.documents[temp].data['maxSlots'] -
          docs2.documents[temp].data['fillSlots'];
      String pName = docs2.documents[temp].data['parkName'];

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
            docs2.documents[temp].data['parkLocation'].latitude,
            docs2.documents[temp].data['parkLocation'].longitude),
        infoWindow: InfoWindow(
            title: docs2.documents[temp].data['parkName'],
            snippet: 'No. of available slots = $availableSlots'),
        onTap: () {
          populateClients();
          final snackBar = SnackBar(
              backgroundColor: Colors.black,
              //duration: Duration(milliseconds: 500),
              content: Text(
                '$pName',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              action: SnackBarAction(
                  label: 'Click here to park',
                  textColor: Colors.yellow,
                  disabledTextColor: Colors.pinkAccent,
                  onPressed: () async {
                    Firestore.instance
                        .collection('parkingmarkers')
                        .getDocuments()
                        .then((docs1) {
                      if (docs1.documents.isNotEmpty) {
                        for (int j = 0; j < docs1.documents.length; ++j) {
                          if (requestId == docs1.documents[j].documentID) {

                           String pay;
                              print('&&&&&&&&&&&&&&&&&&&&&&');
                            if(docs1.documents[j].data['firstHourPayment']==0 && docs1.documents[j].data['nextHoursPayment']==0){
                              pay='Free';
                              print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+pay);
                            }else {
                              print("Im here @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                            //print('####################################'+docs1.documents[j].data['firstHourPayment']);
                              pay = 'First Hour   : '+' Rs.'+docs1.documents[j].data['firstHourPayment'].toString()+'\n'+'Next Hours : '+'Rs.'+docs1.documents[j].data['nextHoursPayment'].toString();
                              print('###########################'+pay);
                            }

                            if ((docs1.documents[j].data['maxSlots'] -
                                docs1.documents[j].data['fillSlots']) > 0) {
                              animated_dialog_box.showRotatedAlert(
                                  title: Center(child: Text("CONFIRM",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),)
                                  ),
                                  // IF YOU WANT TO ADD
                                  context: context,
                                  firstButton: MaterialButton(
                                    // FIRST BUTTON IS REQUIRED
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      color: Colors.white,
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Firestore.instance
                                            .collection('parkingmarkers')
                                            .getDocuments()
                                            .then((docs3) async {
                                          for (int h = 0; h < docs3.documents.length; ++h) {
                                            if(requestId == docs3.documents[h].documentID){
                                              if ((docs3.documents[h].data['maxSlots'] -
                                                  docs3.documents[h].data['fillSlots']) >
                                                  0) {
                                               // int newValue = docs3.documents[h].data['fillSlots'];
                                                String valueFromFirebaseForQR='Easy Parking '+docs3.documents[h].data['parkName']+' '+requestId+' Start';


                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                        //Time(hemawelemaoni: hemawelemaoni,)
                                                        ScanStartQR(hemawelemaoni: hemawelemaoni,parkRequestId: requestId,valueFromFirebaseForQR: valueFromFirebaseForQR,paName:pName)
                                                    ));

                                              } else {
                                                animated_dialog_box.showRotatedAlert(
                                                    title: Center(child: Text("SORRY",
                                                      style: TextStyle(
                                                      decoration: TextDecoration.underline,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    )),
                                                    // IF YOU WANT TO ADD
                                                    context: context,
                                                    firstButton: MaterialButton(
                                                      // FIRST BUTTON IS REQUIRED
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(40),
                                                      ),
                                                      color: Colors.white,
                                                      child: Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop(
                                                            Navigator.of(context).pop(
                                                                populateClients()));
                                                      },
                                                    ),
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      color: Colors.red,
                                                    ),
                                                    // IF YOU WANT TO ADD ICON
                                                    yourWidget: Container(
                                                      child: Column(
                                                      children: <Widget>[
                                                      new Padding(
                                                      padding: EdgeInsets.only(top: 20.0)),
                                                      Text(
                                                      '\"$pName\"\n',
                                                      style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.pink,
                                                      fontWeight: FontWeight.bold
                                                      ),
                                                      ),
                                                      new Padding(
                                                      padding: EdgeInsets.only(top: 25.0)),
                                                      Text(
                                                      'There are no any available spaces in here.'),
                                                      ])));
                                              }
                                            }}
                                        },);}
                                  ),
                                  secondButton: MaterialButton(
                                    // OPTIONAL BUTTON
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    color: Colors.white,
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop(populateClients());
                                    },
                                  ),
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.red,
                                  ),
                                  // IF YOU WANT TO ADD ICON
                                  yourWidget: Container(
                                    child: Column(
                                      children: <Widget>[
                                        new Padding(
                                            padding: EdgeInsets.only(top: 20.0)),
                                        Text(
                                          '\"$pName\"\n',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        new Padding(
                                            padding: EdgeInsets.only(top: 30.0)),
                                        Text(
                                            'Press \'OK\' button and scan QR code in the park.',
                                        ),
                                        new Padding(
                                            padding: EdgeInsets.only(top: 20.0)),

                                        Text(
                                          'Payment',
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        new Padding(
                                            padding: EdgeInsets.only(top: 5.0)),
                                        Text(
                                          '$pay',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),

                                      ],
                                    )));
                            } else {
                              animated_dialog_box.showRotatedAlert(
                                  title: Center(child: Text("SORRY",
                                    style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  )),
                                  // IF YOU WANT TO ADD
                                  context: context,
                                  firstButton: MaterialButton(
                                    // FIRST BUTTON IS REQUIRED
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    color: Colors.white,
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop(populateClients());
                                    },
                                  ),
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.red,
                                  ),
                                  // IF YOU WANT TO ADD ICON
                                  yourWidget: Container(
                                      child: Column(
                                          children: <Widget>[
                                    new Padding(
                                        padding: EdgeInsets.only(top: 20.0)),
                                    Text(
                                      '\"$pName\"\n',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.pink,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    new Padding(
                                        padding: EdgeInsets.only(top: 25.0)),
                                    Text(
                                        'There are no any available spaces in here.'),
                                  ])
                              ));
                            }
                          }
                        }
                        ;

                      }
                    });
                  }));

          Scaffold.of(context).showSnackBar(snackBar);
        },
      );
      setState(() {
        markers[markerId] = marker;
        print(markerId);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 125.0,
                width: MediaQuery.of(context).size.width,
                child: mapToggle
                    ? GoogleMap(
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(markers.values),

                  onMapCreated: _onMapCreated,
                  //mapType: MapType.satellite,
                  compassEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation.latitude,
                          currentLocation.longitude),
                      zoom: 12.0),
                  //zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  //myLocationButtonEnabled: false,
                )

                    : Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          )
        ]));
  }
}


