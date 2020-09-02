import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/screens/scanqr/scan_leave_qr.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';


class StopWatchPage extends StatefulWidget {

  String hemawelemaoni;
  String stopWatchTimetodisplay;
  StopWatchPage({this.hemawelemaoni,this.stopWatchTimetodisplay});


  @override
  _StopWatchPageState createState() => _StopWatchPageState(hemawelemaoni:hemawelemaoni,stopWatchTimetodisplay:stopWatchTimetodisplay);
}

class _StopWatchPageState extends State<StopWatchPage> with SingleTickerProviderStateMixin{

  String hemawelemaoni;
  String stopWatchTimetodisplay;
  _StopWatchPageState({this.hemawelemaoni,this.stopWatchTimetodisplay});


  ModalRoute<dynamic> _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route?.removeScopedWillPopCallback(_onWillPop);
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(_onWillPop);
  }

  @override
  void dispose() {
    _route?.removeScopedWillPopCallback(_onWillPop);
    super.dispose();
  }

  Future<bool> _onWillPop() => Future.value(false);


  //String timeForPaymentCalculation='00:00:00';
  String time='00:00:00';



  TabController _tabController;


  @override
  void initState() {
    _tabController = new TabController(length: 1, vsync: this);
    super.initState();
  }

  var swatch = Stopwatch();
  final dur=const Duration(seconds: 1);


  void starttimer(){
    Timer(dur, keeprunning);
  }

  trueTime() async{
    var seconds = swatch.elapsed.inSeconds;
    var realTime = stopWatchTimetodisplay.split(":");

    var realTimeSeconds = int.parse(realTime[0])*3600 + int.parse(realTime[1])*60 + int.parse(realTime[2]);
    int t = seconds + realTimeSeconds;

    int hrs = (t~/3600);
    int sec = t % 60;
    int min = ((t%3600) - sec)~/60;

    return hrs.toString().padLeft(2,'0') + ":" + min.toString().padLeft(2, "0") + ":" + sec.toString().padLeft(2, "0");
  }

  void keeprunning() async{
    if(swatch.isRunning){
      starttimer();
    }


      var t = await trueTime();
      //print(time);
      setState(() {
        time = t;
      });

  }

  void startstopwatch(){
    setState(() {

    });
    swatch.start();
    starttimer();
  }


  Widget stopwatch(){
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () async {
                          animated_dialog_box.showRotatedAlert(
                              title: Center(child: Text("CONFIRM")),
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
                                    Firestore.instance.collection(
                                        'userdetails')
                                        .getDocuments()
                                        .then((doc) async {
                                      for (int a = 0; a <
                                          doc.documents.length; ++a) {
                                        if (hemawelemaoni ==
                                            doc.documents[a]
                                                .documentID) {
                                          String parkleavingId = doc
                                              .documents[a]
                                              .data['park'];

                                          Firestore.instance
                                              .collection(
                                              'parkingmarkers')
                                              .getDocuments()
                                              .then((docs3) async {
                                            for (int h = 0; h <
                                                docs3.documents
                                                    .length; ++h) {
                                              if (parkleavingId ==
                                                  docs3.documents[h]
                                                      .documentID) {
                                                String valueFromFirebaseForQRInLeaving = 'Easy Parking '+docs3.documents[h].data['parkName'] + ' ' + parkleavingId+' Leave';
                                                String pName=docs3
                                                    .documents[h]
                                                    .data['parkName'];

                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                        //Time(hemawelemaoni: hemawelemaoni,)
                                                        ScanLeaveQR(hemawelemaoni: hemawelemaoni,valueFromFirebaseForQRLeaving: valueFromFirebaseForQRInLeaving,paName:pName)
                                                    ));

                                              }
                                            }
                                          });
                                        }
                                      }
                                    });

                                    }
                              ),
                              secondButton: MaterialButton(
                                // OPTIONAL BUTTON
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                color: Colors.white,
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
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
                          padding: EdgeInsets.only(top: 25.0)),
                          Text(
                          'Press \'OK\' button and scan QR code to leave the park.',
                          ),
                          new Padding(
                          padding: EdgeInsets.only(top: 20.0)),

                          ],
                                 )));

                          },
                        color:Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: 80.0,
                          vertical: 25.0,
                        ),
                        child: Text(
                          'LEAVE',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.black
                          ),
                        ),

                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    startstopwatch();
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          stopwatch(),
        ],
        controller: _tabController,
      ),
    );
  }
}
