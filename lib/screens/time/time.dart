import 'package:flutter/material.dart';
import 'package:flutterapp/models/user_details.dart';
import 'package:flutterapp/screens/home/profile_view.dart';
import 'package:flutterapp/screens/time/my_time_page.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/services/database.dart';
import 'package:provider/provider.dart';


class Time extends StatefulWidget {
  String hemawelemaoni;
  Time({this.hemawelemaoni});

  @override
  _TimeState createState() => _TimeState(hemawelemaoni:hemawelemaoni);
}

class _TimeState extends State<Time> {
  String hemawelemaoni;
  _TimeState({this.hemawelemaoni});

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


  final AuthService _auth =AuthService();

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return StreamProvider<List<UserDetails>>.value(
        value: DatabaseService().userdetails,
        child:Scaffold(

          backgroundColor: Colors.brown[50],

          //body:UserDetailsList(),
          body: MyTimePage(hemawelemaoni:hemawelemaoni)

        ));
  }
}

