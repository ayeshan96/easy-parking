import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/home/home.dart';
import 'package:flutterapp/screens/time/time.dart';
import 'package:flutterapp/shared/frequent.dart';
import 'package:flutterapp/shared/loading.dart';

class Temp extends StatefulWidget {
  String hemawelemaoni;
  Temp({this.hemawelemaoni});
  
  @override
  _TempState createState() => _TempState(hemawelemaoni:hemawelemaoni);
  
}

class _TempState extends State<Temp> {

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
  _TempState({this.hemawelemaoni});

  final _formKey=GlobalKey<FormState>();
  bool loading=false;
  
  String name;
  String phoneNumber;
  String email;
  bool check;
  
  @override
  Widget build(BuildContext context) {

    Firestore.instance
        .collection('userdetails')
        .getDocuments()
        .then((docs1) {
      if (docs1.documents.isNotEmpty) {
        for (int j = 0; j < docs1.documents.length; ++j) {
          if (hemawelemaoni == docs1.documents[j].documentID) {
              name=docs1.documents[j].data['name'];
              phoneNumber=docs1.documents[j].data['phoneNumber'];
              email=docs1.documents[j].data['email'];
              check=docs1.documents[j].data['check'];

              print('####################################$name');
          }
        }
      }
    });


    return loading?Loading(): Scaffold(
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
                new Form(
                    key: _formKey,
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
                                    Firestore.instance
                                        .collection('userdetails')
                                        .getDocuments()
                                        .then((docs2) {
                                      if (docs2.documents.isNotEmpty) {
                                        print("At test$hemawelemaoni");

                                        for (int j = 0; j < docs2.documents.length; ++j) {
                                          if (hemawelemaoni == docs2.documents[j].documentID) {
                                            check=docs2.documents[j].data['check'];
                                            print(check);
                                            if(check!=null) {
                                              if (check == true) {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            //Time(hemawelemaoni: hemawelemaoni,
                                                Time(hemawelemaoni: hemawelemaoni,)));

                                              } else {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home(hemawelemaoni: hemawelemaoni,)));
                                              }
                                            }
                                            print('####################################$name');
                                          }
                                        }
                                      }
                                    });
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
