import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/wrapper.dart';
import 'package:flutterapp/shared/loading.dart';
import 'package:gradient_text/gradient_text.dart';


class UpdateUserData extends StatefulWidget {

  String hemawelemaoni;
  String name;
  String phoneNumber;
  UpdateUserData({this.hemawelemaoni,this.name,this.phoneNumber});
  @override
  _UpdateUserDataState createState() => _UpdateUserDataState(hemawelemaoni: hemawelemaoni,name:name,phoneNumber:phoneNumber,n:name,p:phoneNumber);
}

class _UpdateUserDataState extends State<UpdateUserData> {

  String hemawelemaoni;
  String name;
  String phoneNumber;
  String n;
  String p;
  _UpdateUserDataState({this.hemawelemaoni,this.name,this.phoneNumber,this.n,this.p});

  bool loading=false;

  String error='';

  @override
  Widget build(BuildContext context) {
    return loading?Loading(): Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Update Data'),
          backgroundColor: Colors.lightBlue[800],
          elevation: 0.0,


        ),

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

                new Padding(padding: EdgeInsets.only(top:30.0)),

                //welcomeImageAsset(),

                new Padding(padding: EdgeInsets.only(top:15.0)),

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
                              GradientText(
                                  "Name : $n",
                                    gradient: LinearGradient(
                                    colors: [Colors.deepOrange, Colors.deepOrangeAccent, Colors.amber]),
                                    style: TextStyle(fontSize: 20),
                                    //textAlign: TextAlign.start
                              ),
                                new Padding(
                                    padding: EdgeInsets.only(top: 10.0)),
                                new TextFormField(
                                  decoration: new InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.teal,
                                      ),
                                      labelText: "Change Name",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0))),
                                  keyboardType: TextInputType.text,

                                  onChanged: (val){
                                    setState(()=>name=val);
                                  },

                                ),
                                new Padding(
                                    padding: EdgeInsets.only(top: 50.0)),
                                GradientText(
                                    "Phone Number : $p",
                                    gradient: LinearGradient(
                                        colors: [Colors.deepOrange, Colors.deepOrangeAccent, Colors.amber]),
                                    style: TextStyle(fontSize: 20),
                                    //textAlign: TextAlign.start
                                  ),
                                new Padding(
                                    padding: EdgeInsets.only(top: 10.0)),
                                new TextFormField(
                                  decoration: new InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.teal,
                                      ),
                                      labelText: "Change Phone Number",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0))),
                                  keyboardType: TextInputType.phone,

                                  onChanged: (val){
                                    setState(()=>phoneNumber=val);
                                  },

                                ),

                                new Padding(
                                    padding: EdgeInsets.only(top: 50.0)),
                                new RaisedButton(
                                  color: Colors.teal,
                                  elevation: 6.0,
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () async{

                                    if(name==''||name==null||name==""){
                                      name=n;
                                    }
                                    if(phoneNumber==''||phoneNumber==null||phoneNumber==""||phoneNumber.length!=10){
                                      phoneNumber=p;
                                    }

                                    Firestore.instance
                                        .collection('userdetails')
                                        .getDocuments()
                                        .then((docsUser50) async {
                                      for (int y = 0; y < docsUser50.documents.length; ++y) {
                                        if(hemawelemaoni == docsUser50.documents[y].documentID){
                                          if(name!=''||name!=null||name!="") {
                                            Firestore.instance
                                                .collection('userdetails')
                                                .document(hemawelemaoni)
                                                .updateData(
                                                {'name': name,
                                                }
                                            )
                                                .catchError((e) {
                                              print(e);
                                            });
                                          };
                                          if(phoneNumber!=''||phoneNumber!=null||phoneNumber!="") {
                                            Firestore.instance
                                                .collection('userdetails')
                                                .document(hemawelemaoni)
                                                .updateData(
                                                {'phoneNumber': phoneNumber,
                                                }
                                            )
                                                .catchError((e) {
                                              print(e);
                                            });
                                          }
                                          if(name!=n||phoneNumber!=p) {
                                            return Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Wrapper()));
                                          }

                                        }}});

                                    //setState(() {});

                                  },
                                  splashColor: Colors.red,
                                ),
                                SizedBox(height: 12.0,),
                                Text(
                                  error,
                                  style: TextStyle(color: Colors.red,fontSize: 14.0),

                                )
                              ],
                            ))))
              ])
        ]));
  }

}
