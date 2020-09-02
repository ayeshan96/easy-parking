import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/screens/home/update_user_data.dart';
import 'package:gradient_text/gradient_text.dart';

class ProfileView extends StatefulWidget {
  String hemawelemaoni;
  ProfileView({this.hemawelemaoni});


  @override
  _ProfileViewState createState() => _ProfileViewState(hemawelemaoni:hemawelemaoni);
}

class _ProfileViewState extends State<ProfileView> {

  String hemawelemaoni;
  _ProfileViewState({this.hemawelemaoni});

  final db = Firestore.instance;

  var email,name,phoneNumber,lastPayment;


  getUserDetails() async{
    db.collection('userdetails').document(hemawelemaoni).get().then((value){
      setState(() {
        email = value.data['email'];
        name=value.data['name'];
        phoneNumber=value.data['phoneNumber'];
        lastPayment=value.data['lastPayment'];

      });
    });
  }


 final _formkey=GlobalKey<FormState>();
    @override
    void initState() {
    // TODO: implement initState
      getUserDetails();

      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return userWidget();
  }

  Widget userWidget() {
      getUserDetails();
      return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GradientText(
            "Profile Details",
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepOrange, Colors.pink]),
            style: TextStyle(fontSize: 30),
            //textAlign: TextAlign.start
          ),
          new Padding(
              padding: EdgeInsets.only(top: 50.0)),
          Text(
            'Name : ${name} \n',
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            'Email : ${email} \n',
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            'Phone Number : ${phoneNumber} \n',
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            'Last Payment : Rs.${lastPayment}.00 \n',
            style: TextStyle(fontSize: 18.0),
          ),

          new Padding(
              padding: EdgeInsets.only(top: 10.0)),

          Row(
            children: <Widget>[
              Expanded(
                  child:new RaisedButton(
              color: Colors.black45,
              elevation: 6.0,
              child: Text(
                'Update User Details',textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white70,
                ),
              ),
              onPressed: () async{

                Firestore.instance
                    .collection('userdetails')
                    .getDocuments()
                    .then((docs3) async {
                  for (int h = 0; h < docs3.documents.length; ++h) {
                    if(hemawelemaoni == docs3.documents[h].documentID){
                      String name=docs3.documents[h].data['name'];
                      String phoneNumber=docs3.documents[h].data['phoneNumber'];

                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) =>
                              //Time(hemawelemaoni: hemawelemaoni,)
                              UpdateUserData(hemawelemaoni: hemawelemaoni,name:name,phoneNumber:phoneNumber)
                          ));
                      //setState(() {});

                    }}});

              },
              splashColor: Colors.red,
            )),
          ]
          )



        ],

      ),
    );
  }
}
