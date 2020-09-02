import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/time/time.dart';
import 'package:flutterapp/screens/wrapper.dart';
import 'package:flutterapp/shared/frequent.dart';
import 'package:flutterapp/shared/loading.dart';

class ScanStartQR2 extends StatefulWidget {

  String hemawelemaoni;
  String parkRequestId;

  ScanStartQR2({this.hemawelemaoni, this.parkRequestId});


  @override
  _ScanStartQR2State createState() => _ScanStartQR2State(hemawelemaoni: hemawelemaoni,parkRequestId: parkRequestId);
}

class _ScanStartQR2State extends State<ScanStartQR2> {

  String hemawelemaoni;
  String parkRequestId;

  _ScanStartQR2State({this.hemawelemaoni, this.parkRequestId});


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



  bool loading=false;




  @override
  void initState(){
    super.initState();
  function();
  }

  function(){
    Firestore.instance
        .collection('parkingmarkers')
        .getDocuments()
        .then((docs3) async {
      for (int h = 0; h < docs3.documents.length; ++h) {
        if (parkRequestId == docs3.documents[h].documentID) {
          int newValue = docs3.documents[h].data['fillSlots'];
          String parkName = docs3.documents[h].data['parkName'];

          //print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
          if ((docs3.documents[h].data['maxSlots'] -
              docs3.documents[h].data['fillSlots']) >
              0) {
            Firestore.instance
                .collection('parkingmarkers')
                .document(parkRequestId)
                .updateData(
                {'fillSlots': (newValue + 1)})
                .catchError((e) {
              print(e);
            });
            Firestore.instance
                .collection('userdetails')
                .getDocuments()
                .then((docsUser1) async {
              for (int z = 0; z < docsUser1.documents.length; ++z) {
                if (hemawelemaoni ==
                    docsUser1.documents[z].documentID) {
                  Firestore.instance
                      .collection('userdetails')
                      .document(hemawelemaoni)
                      .updateData(
                      {'check': true,
                        'park': parkRequestId}
                  )
                      .catchError((e) {
                    print(e);
                  });
                  return Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Time(hemawelemaoni: hemawelemaoni,
                              )));
                }
              }
            });
          } else {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
              title: Center(child:Text("SORRY",
                style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              )),
              ),
              content: Text("There are no any available spaces at \"$parkName\"."),
              actions: [
                MaterialButton(
                  // FIRST BUTTON IS REQUIRED
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.white,
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Wrapper(
                                )));
                  },
                ),

              ],)
                );

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
