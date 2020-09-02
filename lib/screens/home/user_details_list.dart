import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterapp/models/user_details.dart';
import 'package:flutterapp/screens/home/userdetails_tile.dart';

class UserDetailsList extends StatefulWidget {
  @override
  _UserDetailsListState createState() => _UserDetailsListState();
}

class _UserDetailsListState extends State<UserDetailsList> {
  @override
  Widget build(BuildContext context) {

    final userDetails=Provider.of<List<UserDetails>>(context);

    return ListView.builder(
      itemCount: userDetails.length,
      itemBuilder: (context,index){
        return UserDetailsTile(userDetail:userDetails[index]);
      },
    );
  }
}
