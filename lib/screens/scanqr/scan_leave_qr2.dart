import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/payment/payment_store.dart';
import 'package:flutterapp/shared/frequent.dart';
import 'package:flutterapp/shared/loading.dart';
import 'package:http/http.dart';

class ScanSLeaveQR2 extends StatefulWidget {

  String hemawelemaoni;

  ScanSLeaveQR2({this.hemawelemaoni,});


  @override
  _ScanSLeaveQR2State createState() => _ScanSLeaveQR2State(hemawelemaoni: hemawelemaoni,);
}

class _ScanSLeaveQR2State extends State<ScanSLeaveQR2> {


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


  String hemawelemaoni;

  _ScanSLeaveQR2State({this.hemawelemaoni});


  bool loading=false;




  @override
  void initState(){
    super.initState();
   getRealTimePayment();
  }

  getRealTimePayment()async {

    String tempDate;
    String tempTime;
    String park;
    int lastPayment;


    int temphours;
    int tempminutes;
    int tempseconds;

    int firsthourpayment;
    int nexthourspayment;

print('CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC');

    Response response = await get(
        'http://worldtimeapi.org/api/timezone/Asia/Colombo');
    Map data = jsonDecode(response.body);

    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1, 3);


    //create datetime object
    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));

    // print('^^^^^^^^^^^^^^^^^^$now^^^^^^^^^^^^^^^');

    String secondDate = datetime.substring(0, 10);


    String secondTime = datetime.substring(11, 19);

    while (datetime == null) {

      print('#############$secondDate######');
      print('#############$secondTime######');

    }

    Firestore.instance
        .collection('userdetails')
        .getDocuments()
        .then((docsUser1) async {
      for (int h = 0; h < docsUser1.documents.length; ++h) {
        if (hemawelemaoni == docsUser1.documents[h].documentID) {
          if (docsUser1.documents[h].data['checkingTime'] == true) {
            tempDate=docsUser1.documents[h].data['firstDate'];
            tempTime=docsUser1.documents[h].data['firstTime'];
            park=docsUser1.documents[h].data['park'];

            if(tempDate==secondDate){

              int finalseconds=((((int.parse(secondTime.substring(0,2))-int.parse(tempTime.substring(0,2)))*60)+(int.parse(secondTime.substring(3,5))-int.parse(tempTime.substring(3,5))))*60)+int.parse(secondTime.substring(6,8))-int.parse(tempTime.substring(6,8));

              String hours;
              String minutes;
              String seconds;
              temphours=(finalseconds/3600).toInt();
              tempminutes=((finalseconds%3600)/60).toInt();
              tempseconds=((finalseconds%3600)%60).toInt();



            }else{
              int finalseconds=((((24-int.parse(tempTime.substring(0,2)))*60)+(0-int.parse(tempTime.substring(3,5))))*60)+(0-int.parse(tempTime.substring(6,8)));
              finalseconds=finalseconds+ ((((int.parse(secondTime.substring(0,2)))*60)+int.parse(secondTime.substring(3,5)))*60)+int.parse(secondTime.substring(6,8));

              String hours;
              String minutes;
              String seconds;
              temphours=(finalseconds/3600).toInt();


              DateTime dateTimeCreatedAt = DateTime.parse('$tempDate');
              DateTime dateTimeNow = DateTime.now();
              final differenceInDays = dateTimeNow.difference(dateTimeCreatedAt).inDays;

              String diffDays='$differenceInDays';
              temphours=temphours+(((int.parse(diffDays))-1)*24);

              tempminutes=((finalseconds%3600)/60).toInt();

              tempseconds=((finalseconds%3600)%60).toInt();



            }
            String fiTime='Parking Time : '+temphours.toString().padLeft(2,'0')+'h '+tempminutes.toString().padLeft(2, "0")+'min';

            Firestore.instance
                .collection('parkingmarkers')
                .getDocuments()
                .then((docs1) async {
              for (int a = 0; a < docs1.documents.length; ++a) {
                if (park == docs1.documents[a].documentID) {
                  firsthourpayment = docs1.documents[a].data['firstHourPayment'];
                  nexthourspayment = docs1.documents[a].data['nextHoursPayment'];
                  int slo=docs1.documents[a].data['fillSlots'];

                  Firestore.instance
                      .collection('parkingmarkers')
                      .document(park)
                      .updateData(
                      {'fillSlots': slo-1,
                      }
                  )
                      .catchError((e) {
                    print(e);
                  });


                  if(temphours==0){
                    lastPayment=firsthourpayment;

                    Firestore.instance
                        .collection('userdetails')
                        .getDocuments()
                        .then((docsUser50) async {
                      for (int y = 0; y < docsUser50.documents.length; ++y) {
                        if(hemawelemaoni == docsUser50.documents[y].documentID){
                          if(docsUser50.documents[y].data['checkingTime']==true) {
                            Firestore.instance
                                .collection('userdetails')
                                .document(hemawelemaoni)
                                .updateData(
                                {'check': false,
                                  'checkingTime': false,
                                  'lastPayment': lastPayment,
                                }
                            )
                                .catchError((e) {
                              print(e);
                            });
                          }}}});



                    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentStore(hemawelemaoni: hemawelemaoni, finalPayment: lastPayment.toString(),fiTime:fiTime)));

                  }else{
                    lastPayment=firsthourpayment+((temphours-1)*nexthourspayment)+(((nexthourspayment/60)*tempminutes).ceil());

                    Firestore.instance
                        .collection('userdetails')
                        .getDocuments()
                        .then((docsUser50) async {
                      for (int y = 0; y < docsUser50.documents.length; ++y) {
                        if(hemawelemaoni == docsUser50.documents[y].documentID){
                          if(docsUser50.documents[y].data['checkingTime']==true) {
                            Firestore.instance
                                .collection('userdetails')
                                .document(hemawelemaoni)
                                .updateData(
                                {'check': false,
                                  'checkingTime': false,
                                  'lastPayment': lastPayment,
                                }
                            )
                                .catchError((e) {
                              print(e);
                            });
                          }}}});

                    return Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PaymentStore(hemawelemaoni: hemawelemaoni, finalPayment: lastPayment.toString(),fiTime:fiTime)));

                  }
                  print('&&&&&&&&&&&$hemawelemaoni&&&&&&&&&&&&$park&&&&&$temphours&&&&&&&&$tempminutes&&&&&&&&&&&&&$tempseconds&&&&&&&&&&&&&&&&&&&$lastPayment&&&&&&&&&');

                }

              }
            });


          }
        }
      }});

  }


  @override
  Widget build(BuildContext context) {


    return loading?Loading():Scaffold(
        backgroundColor: Colors.black,
        body: new Stack(fit: StackFit.expand, children: <Widget>[
          new Image(
            image: new AssetImage("images/welcomeimage.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          new ListView(

            //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SizedBox(
                // height: 80.0,
                //),
                //CircleAvatar(
                //backgroundColor: Colors.black87,
                //radius: 50.0,
                //),
                new Padding(
                    padding: EdgeInsets.only(top: 70.0)),

                welcomeImageAsset(),
                /* new Form(
                    child: new Theme(
                        data: new ThemeData(
                            brightness: Brightness.dark,
                            primarySwatch: Colors.teal,
                            inputDecorationTheme: new InputDecorationTheme(
                                labelStyle: new TextStyle(
                                    color: Colors.teal, fontSize: 20.0))),
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[

                                new Padding(
                                    padding: EdgeInsets.only(top: 150.0)),
                                new RaisedButton(
                                  color: Colors.amberAccent,
                                  elevation: 6.0,
                                  child: Text(
                                    'Click here to continue.....',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () async{
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Wrapper()));
                                    //setState(() {});

                                  },
                                  splashColor: Colors.red,
                                ),
                                SizedBox(height: 12.0,),

                              ],
                            ))))*/
              ])
        ]));
  }


}
