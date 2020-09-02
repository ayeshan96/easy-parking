import 'package:flutter/material.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:provider/provider.dart';
import './screens/wrapper.dart';
import './models/user.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner:false,
        home: Wrapper(),
      ),
    );
  }


}

