import 'package:flutter/material.dart';
import 'package:flutterapp/models/user_details.dart';

class UserDetailsTile extends StatelessWidget {
  final UserDetails userDetail;
  UserDetailsTile({this.userDetail});

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0,0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.indigoAccent,
          ),
          title: Text(userDetail.name),
          subtitle: Text('${userDetail.phoneNumber}\n${userDetail.email}'),
        ),
      ),


    );
  }
}
