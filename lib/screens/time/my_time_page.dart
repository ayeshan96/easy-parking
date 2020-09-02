import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/time/stop_watch_page.dart';
import 'package:flutterapp/shared/frequent.dart';
import 'package:http/http.dart';

class MyTimePage extends StatefulWidget {

  String hemawelemaoni;
  MyTimePage({this.hemawelemaoni});

  @override
  _MyTimePageState createState() => _MyTimePageState(hemawelemaoni: hemawelemaoni);
}

class _MyTimePageState extends State<MyTimePage>{


  String hemawelemaoni;
  _MyTimePageState({this.hemawelemaoni});

  String stopWatchTimetodisplay='00:00:00';

  void getTime()async{
    Response response=await get('http://worldtimeapi.org/api/timezone/Asia/Colombo');
    Map data=jsonDecode(response.body);
    //print('########################$data');

    //get properties from data
    String datetime=data['datetime'];
    String offset=data['utc_offset'].substring(1,3);

    //print('################################$datetime');
    //print('@@@@@@@@@@@@@@@@$offset');

    //create datetime object
    DateTime now=DateTime.parse(datetime);
    now=now.add(Duration(hours:int.parse(offset)));
   // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$now');

    //int year=int.parse(datetime.substring(0,4));
    //int month=int.parse(datetime.substring(5,7));
    //int date=int.parse(datetime.substring(8,10));

   /* String year=(datetime.substring(0,4));
    String month=(datetime.substring(5,7));
    String date=(datetime.substring(8,10));*/

   String firstDate=datetime.substring(0,10);

    /*String hours=datetime.substring(11,13);
    String minutes=datetime.substring(14,16);
    String seconds=datetime.substring(17,19);*/

    String firstTime=datetime.substring(11,19);

    while(datetime==null) {
      /*  print('#############$year###################$datetime');
    print('#############$month######');
    print('#############$date######');
    print('#############$hours######');
    print('#############$minutes######');
    print('#############$seconds######');*/
      print('#############$firstDate######');
      print('#############$firstTime######');

      //print('@@@@@@@@@@@@@@@@@@@@@@@@@');
    }


    Firestore.instance
        .collection('userdetails')
        .getDocuments()
        .then((docsUser1) async {
      for (int h = 0; h < docsUser1.documents.length; ++h) {
        if(hemawelemaoni == docsUser1.documents[h].documentID){
          if(docsUser1.documents[h].data['checkingTime']==false) {
            Firestore.instance
                .collection('userdetails')
                .document(hemawelemaoni)
                .updateData(
                {'firstDate': firstDate,
                  'firstTime': firstTime,
                  'checkingTime': true,
                }
            )
                .catchError((e) {
              print(e);
            });
          }}}});


  }


  getRealTime()async {
    String tempDate;
    String tempTime;

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

            if(tempDate==secondDate){

              int finalseconds=((((int.parse(secondTime.substring(0,2))-int.parse(tempTime.substring(0,2)))*60)+(int.parse(secondTime.substring(3,5))-int.parse(tempTime.substring(3,5))))*60)+int.parse(secondTime.substring(6,8))-int.parse(tempTime.substring(6,8));

              String hours;
              String minutes;
              String seconds;
              int temphours=(finalseconds/3600).toInt();
              if(temphours<10) {
                hours = '0${temphours}';
              }else{
                hours = '${temphours}';
              }

              int tempminutes=((finalseconds%3600)/60).toInt();
              if(tempminutes<10) {
                minutes='0${tempminutes}';
              }else{
                minutes='${tempminutes}';
              }


              int tempseconds=((finalseconds%3600)%60).toInt();
              if(tempseconds<10) {
                seconds='0${tempseconds}';
              }else{
                seconds='${tempseconds}';
              }


              stopWatchTimetodisplay='${hours}:${minutes}:${seconds}';


             // print('##$secondTime############$tempTime################$stopWatchTimetodisplay#########');
              //print('%%%%%$temphours%%%%%%%%$tempminutes%%%%%%%%%%%$tempseconds%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');


            }else{
              int finalseconds=((((24-int.parse(tempTime.substring(0,2)))*60)+(0-int.parse(tempTime.substring(3,5))))*60)+(0-int.parse(tempTime.substring(6,8)));
              finalseconds=finalseconds+ ((((int.parse(secondTime.substring(0,2)))*60)+int.parse(secondTime.substring(3,5)))*60)+int.parse(secondTime.substring(6,8));

              String hours;
              String minutes;
              String seconds;
              int temphours=(finalseconds/3600).toInt();


              DateTime dateTimeCreatedAt = DateTime.parse('$tempDate');
              DateTime dateTimeNow = DateTime.now();
              final differenceInDays = dateTimeNow.difference(dateTimeCreatedAt).inDays;

              String diffDays='$differenceInDays';
              temphours=temphours+(((int.parse(diffDays))-1)*24);

              if(temphours<10) {
                hours = '0${temphours}';
              }else{
                hours = '${temphours}';
              }


              int tempminutes=((finalseconds%3600)/60).toInt();
              if(tempminutes<10) {
                minutes='0${tempminutes}';
              }else{
                minutes='${tempminutes}';
              }


              int tempseconds=((finalseconds%3600)%60).toInt();
              if(tempseconds<10) {
                seconds='0${tempseconds}';
              }else{
                seconds='${tempseconds}';
              }


              stopWatchTimetodisplay='${hours}:${minutes}:${seconds}';


            }


          }else{
              stopWatchTimetodisplay='00:00:00';
              //print(stopWatchTimetodisplay);
          }

        }
      }
    });
    return stopWatchTimetodisplay;
  }


  @override
  void initState(){
    super.initState();
    getTime();
    getRealTime();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
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

                new Padding(
                    padding: EdgeInsets.only(top: 70.0)),

                welcomeImageAsset(),
                new Form(
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
                                    await getRealTime();
                                    var time = await getRealTime();

                                    if(time!='00:00:00' || time != null || time != "");{

                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StopWatchPage(hemawelemaoni: hemawelemaoni,stopWatchTimetodisplay:time.toString())));

                                    }



                                    //setState(() {});

                                  },
                                  splashColor: Colors.red,
                                ),
                                SizedBox(height: 12.0,),

                              ],
                            ))))
              ])
        ]));

  }
}
