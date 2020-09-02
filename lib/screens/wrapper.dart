import 'package:flutter/material.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/screens/authenticate/authenticate.dart';
import 'package:flutterapp/screens/temp.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final user = Provider.of<User>(context);
    print(user);

    if (user == null) {
      return Authenticate();
    } else {
      String hemawelemaoni=user.uid;

      return Temp(hemawelemaoni:hemawelemaoni);
  }
}
}